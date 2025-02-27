use crate::component::func::{Memory, MemoryMut, Options};
use crate::component::{ComponentParams, ComponentType, Lift, Lower, Type, Val};
use crate::{AsContextMut, StoreContextMut, ValRaw};
use anyhow::{anyhow, bail, Context, Result};
use std::any::Any;
use std::mem::{self, MaybeUninit};
use std::panic::{self, AssertUnwindSafe};
use std::ptr::NonNull;
use std::sync::Arc;
use wasmtime_environ::component::{
    CanonicalAbiInfo, ComponentTypes, StringEncoding, TypeFuncIndex, MAX_FLAT_PARAMS,
    MAX_FLAT_RESULTS,
};
use wasmtime_runtime::component::{
    InstanceFlags, VMComponentContext, VMLowering, VMLoweringCallee,
};
use wasmtime_runtime::{VMCallerCheckedAnyfunc, VMMemoryDefinition, VMOpaqueContext};

/// Trait representing host-defined functions that can be imported into a wasm
/// component.
///
/// For more information see the
/// [`func_wrap`](crate::component::LinkerInstance::func_wrap) documentation.
pub trait IntoComponentFunc<T, Params, Return> {
    /// Host entrypoint from a cranelift-generated trampoline.
    ///
    /// This function has type `VMLoweringCallee` and delegates to the shared
    /// `call_host` function below.
    #[doc(hidden)]
    extern "C" fn entrypoint(
        cx: *mut VMOpaqueContext,
        data: *mut u8,
        flags: InstanceFlags,
        memory: *mut VMMemoryDefinition,
        realloc: *mut VMCallerCheckedAnyfunc,
        string_encoding: StringEncoding,
        storage: *mut ValRaw,
        storage_len: usize,
    );

    #[doc(hidden)]
    fn into_host_func(self) -> Arc<HostFunc>;
}

pub struct HostFunc {
    entrypoint: VMLoweringCallee,
    typecheck: Box<dyn (Fn(TypeFuncIndex, &Arc<ComponentTypes>) -> Result<()>) + Send + Sync>,
    func: Box<dyn Any + Send + Sync>,
}

impl HostFunc {
    fn new<F, P, R>(func: F, entrypoint: VMLoweringCallee) -> Arc<HostFunc>
    where
        F: Send + Sync + 'static,
        P: ComponentParams + Lift + 'static,
        R: Lower + 'static,
    {
        Arc::new(HostFunc {
            entrypoint,
            typecheck: Box::new(typecheck::<P, R>),
            func: Box::new(func),
        })
    }

    pub(crate) fn new_dynamic<
        T,
        F: Fn(StoreContextMut<'_, T>, &[Val]) -> Result<Val> + Send + Sync + 'static,
    >(
        func: F,
        index: TypeFuncIndex,
        types: &Arc<ComponentTypes>,
    ) -> Arc<HostFunc> {
        let ty = &types[index];

        Arc::new(HostFunc {
            entrypoint: dynamic_entrypoint::<T, F>,
            typecheck: Box::new({
                let types = types.clone();

                move |expected_index, expected_types| {
                    if index == expected_index && Arc::ptr_eq(&types, expected_types) {
                        Ok(())
                    } else {
                        Err(anyhow!("function type mismatch"))
                    }
                }
            }),
            func: Box::new(DynamicContext {
                func,
                types: Types {
                    params: ty
                        .params
                        .iter()
                        .map(|(_, ty)| Type::from(ty, types))
                        .collect(),
                    result: Type::from(&ty.result, types),
                },
            }),
        })
    }

    pub fn typecheck(&self, ty: TypeFuncIndex, types: &Arc<ComponentTypes>) -> Result<()> {
        (self.typecheck)(ty, types)
    }

    pub fn lowering(&self) -> VMLowering {
        let data = &*self.func as *const (dyn Any + Send + Sync) as *mut u8;
        VMLowering {
            callee: self.entrypoint,
            data,
        }
    }
}

fn typecheck<P, R>(ty: TypeFuncIndex, types: &Arc<ComponentTypes>) -> Result<()>
where
    P: ComponentParams + Lift,
    R: Lower,
{
    let ty = &types[ty];
    P::typecheck_params(&ty.params, types).context("type mismatch with parameters")?;
    R::typecheck(&ty.result, types).context("type mismatch with result")?;
    Ok(())
}

/// The "meat" of calling a host function from wasm.
///
/// This function is delegated to from implementations of `IntoComponentFunc`
/// generated in the macro below. Most of the arguments from the `entrypoint`
/// are forwarded here except for the `data` pointer which is encapsulated in
/// the `closure` argument here.
///
/// This function is parameterized over:
///
/// * `T` - the type of store this function works with (an unsafe assertion)
/// * `Params` - the parameters to the host function, viewed as a tuple
/// * `Return` - the result of the host function
/// * `F` - the `closure` to actually receive the `Params` and return the
///   `Return`
///
/// It's expected that `F` will "un-tuple" the arguments to pass to a host
/// closure.
///
/// This function is in general `unsafe` as the validity of all the parameters
/// must be upheld. Generally that's done by ensuring this is only called from
/// the select few places it's intended to be called from.
unsafe fn call_host<T, Params, Return, F>(
    cx: *mut VMOpaqueContext,
    mut flags: InstanceFlags,
    memory: *mut VMMemoryDefinition,
    realloc: *mut VMCallerCheckedAnyfunc,
    string_encoding: StringEncoding,
    storage: &mut [ValRaw],
    closure: F,
) -> Result<()>
where
    Params: Lift,
    Return: Lower,
    F: FnOnce(StoreContextMut<'_, T>, Params) -> Result<Return>,
{
    /// Representation of arguments to this function when a return pointer is in
    /// use, namely the argument list is followed by a single value which is the
    /// return pointer.
    #[repr(C)]
    struct ReturnPointer<T> {
        args: T,
        retptr: ValRaw,
    }

    /// Representation of arguments to this function when the return value is
    /// returned directly, namely the arguments and return value all start from
    /// the beginning (aka this is a `union`, not a `struct`).
    #[repr(C)]
    union ReturnStack<T: Copy, U: Copy> {
        args: T,
        ret: U,
    }

    let cx = VMComponentContext::from_opaque(cx);
    let instance = (*cx).instance();
    let mut cx = StoreContextMut::from_raw((*instance).store());

    let options = Options::new(
        cx.0.id(),
        NonNull::new(memory),
        NonNull::new(realloc),
        string_encoding,
    );

    // Perform a dynamic check that this instance can indeed be left. Exiting
    // the component is disallowed, for example, when the `realloc` function
    // calls a canonical import.
    if !flags.may_leave() {
        bail!("cannot leave component instance");
    }

    // There's a 2x2 matrix of whether parameters and results are stored on the
    // stack or on the heap. Each of the 4 branches here have a different
    // representation of the storage of arguments/returns which is represented
    // by the type parameter that we pass to `cast_storage`.
    //
    // Also note that while four branches are listed here only one is taken for
    // any particular `Params` and `Return` combination. This should be
    // trivially DCE'd by LLVM. Perhaps one day with enough const programming in
    // Rust we can make monomorphizations of this function codegen only one
    // branch, but today is not that day.
    if Params::flatten_count() <= MAX_FLAT_PARAMS {
        if Return::flatten_count() <= MAX_FLAT_RESULTS {
            let storage = cast_storage::<ReturnStack<Params::Lower, Return::Lower>>(storage);
            let params = Params::lift(cx.0, &options, &storage.assume_init_ref().args)?;
            let ret = closure(cx.as_context_mut(), params)?;
            flags.set_may_leave(false);
            ret.lower(&mut cx, &options, map_maybe_uninit!(storage.ret))?;
        } else {
            let storage = cast_storage::<ReturnPointer<Params::Lower>>(storage).assume_init_ref();
            let params = Params::lift(cx.0, &options, &storage.args)?;
            let ret = closure(cx.as_context_mut(), params)?;
            let mut memory = MemoryMut::new(cx.as_context_mut(), &options);
            let ptr = validate_inbounds::<Return>(memory.as_slice_mut(), &storage.retptr)?;
            flags.set_may_leave(false);
            ret.store(&mut memory, ptr)?;
        }
    } else {
        let memory = Memory::new(cx.0, &options);
        if Return::flatten_count() <= MAX_FLAT_RESULTS {
            let storage = cast_storage::<ReturnStack<ValRaw, Return::Lower>>(storage);
            let ptr =
                validate_inbounds::<Params>(memory.as_slice(), &storage.assume_init_ref().args)?;
            let params = Params::load(&memory, &memory.as_slice()[ptr..][..Params::SIZE32])?;
            let ret = closure(cx.as_context_mut(), params)?;
            flags.set_may_leave(false);
            ret.lower(&mut cx, &options, map_maybe_uninit!(storage.ret))?;
        } else {
            let storage = cast_storage::<ReturnPointer<ValRaw>>(storage).assume_init_ref();
            let ptr = validate_inbounds::<Params>(memory.as_slice(), &storage.args)?;
            let params = Params::load(&memory, &memory.as_slice()[ptr..][..Params::SIZE32])?;
            let ret = closure(cx.as_context_mut(), params)?;
            let mut memory = MemoryMut::new(cx.as_context_mut(), &options);
            let ptr = validate_inbounds::<Return>(memory.as_slice_mut(), &storage.retptr)?;
            flags.set_may_leave(false);
            ret.store(&mut memory, ptr)?;
        }
    }

    flags.set_may_leave(true);

    return Ok(());
}

fn validate_inbounds<T: ComponentType>(memory: &[u8], ptr: &ValRaw) -> Result<usize> {
    // FIXME: needs memory64 support
    let ptr = usize::try_from(ptr.get_u32())?;
    if ptr % usize::try_from(T::ALIGN32)? != 0 {
        bail!("pointer not aligned");
    }
    let end = match ptr.checked_add(T::SIZE32) {
        Some(n) => n,
        None => bail!("pointer size overflow"),
    };
    if end > memory.len() {
        bail!("pointer out of bounds")
    }
    Ok(ptr)
}

unsafe fn cast_storage<T>(storage: &mut [ValRaw]) -> &mut MaybeUninit<T> {
    // Assertions that LLVM can easily optimize away but are sanity checks here
    assert!(std::mem::size_of::<T>() % std::mem::size_of::<ValRaw>() == 0);
    assert!(std::mem::align_of::<T>() == std::mem::align_of::<ValRaw>());
    assert!(std::mem::align_of_val(storage) == std::mem::align_of::<T>());

    // This is an actual runtime assertion which if performance calls for we may
    // need to relax to a debug assertion. This notably tries to ensure that we
    // stay within the bounds of the number of actual values given rather than
    // reading past the end of an array. This shouldn't actually trip unless
    // there's a bug in Wasmtime though.
    assert!(std::mem::size_of_val(storage) >= std::mem::size_of::<T>());

    &mut *storage.as_mut_ptr().cast()
}

unsafe fn handle_result(func: impl FnOnce() -> Result<()>) {
    match panic::catch_unwind(AssertUnwindSafe(func)) {
        Ok(Ok(())) => {}
        Ok(Err(e)) => wasmtime_runtime::raise_user_trap(e),
        Err(e) => wasmtime_runtime::resume_panic(e),
    }
}

macro_rules! impl_into_component_func {
    ($num:tt $($args:ident)*) => {
        // Implement for functions without a leading `StoreContextMut` parameter
        #[allow(non_snake_case)]
        impl<T, F, $($args,)* R> IntoComponentFunc<T, ($($args,)*), R> for F
        where
            F: Fn($($args),*) -> Result<R> + Send + Sync + 'static,
            ($($args,)*): ComponentParams + Lift + 'static,
            R: Lower + 'static,
        {
            extern "C" fn entrypoint(
                cx: *mut VMOpaqueContext,
                data: *mut u8,
                flags: InstanceFlags,
                memory: *mut VMMemoryDefinition,
                realloc: *mut VMCallerCheckedAnyfunc,
                string_encoding: StringEncoding,
                storage: *mut ValRaw,
                storage_len: usize,
            ) {
                let data = data as *const Self;
                unsafe {
                    handle_result(|| call_host::<T, _, _, _>(
                        cx,
                        flags,
                        memory,
                        realloc,
                        string_encoding,
                        std::slice::from_raw_parts_mut(storage, storage_len),
                        |_, ($($args,)*)| (*data)($($args),*),
                    ))
                }
            }

            fn into_host_func(self) -> Arc<HostFunc> {
                let entrypoint = <Self as IntoComponentFunc<T, ($($args,)*), R>>::entrypoint;
                HostFunc::new::<_, ($($args,)*), R>(self, entrypoint)
            }
        }

        // Implement for functions with a leading `StoreContextMut` parameter
        #[allow(non_snake_case)]
        impl<T, F, $($args,)* R> IntoComponentFunc<T, (StoreContextMut<'_, T>, $($args,)*), R> for F
        where
            F: Fn(StoreContextMut<'_, T>, $($args),*) -> Result<R> + Send + Sync + 'static,
            ($($args,)*): ComponentParams + Lift + 'static,
            R: Lower + 'static,
        {
            extern "C" fn entrypoint(
                cx: *mut VMOpaqueContext,
                data: *mut u8,
                flags: InstanceFlags,
                memory: *mut VMMemoryDefinition,
                realloc: *mut VMCallerCheckedAnyfunc,
                string_encoding: StringEncoding,
                storage: *mut ValRaw,
                storage_len: usize,
            ) {
                let data = data as *const Self;
                unsafe {
                    handle_result(|| call_host::<T, _, _, _>(
                        cx,
                        flags,
                        memory,
                        realloc,
                        string_encoding,
                        std::slice::from_raw_parts_mut(storage, storage_len),
                        |store, ($($args,)*)| (*data)(store, $($args),*),
                    ))
                }
            }

            fn into_host_func(self) -> Arc<HostFunc> {
                let entrypoint = <Self as IntoComponentFunc<T, (StoreContextMut<'_, T>, $($args,)*), R>>::entrypoint;
                HostFunc::new::<_, ($($args,)*), R>(self, entrypoint)
            }
        }
    }
}

for_each_function_signature!(impl_into_component_func);

unsafe fn call_host_dynamic<T, F>(
    Types { params, result }: &Types,
    cx: *mut VMOpaqueContext,
    mut flags: InstanceFlags,
    memory: *mut VMMemoryDefinition,
    realloc: *mut VMCallerCheckedAnyfunc,
    string_encoding: StringEncoding,
    storage: &mut [ValRaw],
    closure: F,
) -> Result<()>
where
    F: FnOnce(StoreContextMut<'_, T>, &[Val]) -> Result<Val>,
{
    let cx = VMComponentContext::from_opaque(cx);
    let instance = (*cx).instance();
    let mut cx = StoreContextMut::from_raw((*instance).store());

    let options = Options::new(
        cx.0.id(),
        NonNull::new(memory),
        NonNull::new(realloc),
        string_encoding,
    );

    // Perform a dynamic check that this instance can indeed be left. Exiting
    // the component is disallowed, for example, when the `realloc` function
    // calls a canonical import.
    if !flags.may_leave() {
        bail!("cannot leave component instance");
    }

    let param_count = params.iter().map(|ty| ty.flatten_count()).sum::<usize>();

    let args;
    let ret_index;

    if param_count <= MAX_FLAT_PARAMS {
        let iter = &mut storage.iter();
        args = params
            .iter()
            .map(|ty| Val::lift(ty, cx.0, &options, iter))
            .collect::<Result<Box<[_]>>>()?;
        ret_index = param_count;
    } else {
        let param_abi = CanonicalAbiInfo::record(params.iter().map(|t| t.canonical_abi()));

        let memory = Memory::new(cx.0, &options);
        let mut offset = validate_inbounds_dynamic(&param_abi, memory.as_slice(), &storage[0])?;
        args = params
            .iter()
            .map(|ty| {
                let abi = ty.canonical_abi();
                let size = usize::try_from(abi.size32).unwrap();
                Val::load(
                    ty,
                    &memory,
                    &memory.as_slice()[abi.next_field32_size(&mut offset)..][..size],
                )
            })
            .collect::<Result<Box<[_]>>>()?;
        ret_index = 1;
    };

    let ret = closure(cx.as_context_mut(), &args)?;
    flags.set_may_leave(false);
    result.check(&ret)?;

    let result_count = result.flatten_count();
    if result_count <= MAX_FLAT_RESULTS {
        let dst = mem::transmute::<&mut [ValRaw], &mut [MaybeUninit<ValRaw>]>(storage);
        ret.lower(&mut cx, &options, &mut dst.iter_mut())?;
    } else {
        let ret_ptr = &storage[ret_index];
        let mut memory = MemoryMut::new(cx.as_context_mut(), &options);
        let ptr =
            validate_inbounds_dynamic(result.canonical_abi(), memory.as_slice_mut(), ret_ptr)?;
        ret.store(&mut memory, ptr)?;
    }

    flags.set_may_leave(true);

    return Ok(());
}

fn validate_inbounds_dynamic(abi: &CanonicalAbiInfo, memory: &[u8], ptr: &ValRaw) -> Result<usize> {
    // FIXME: needs memory64 support
    let ptr = usize::try_from(ptr.get_u32())?;
    if ptr % usize::try_from(abi.align32)? != 0 {
        bail!("pointer not aligned");
    }
    let end = match ptr.checked_add(usize::try_from(abi.size32).unwrap()) {
        Some(n) => n,
        None => bail!("pointer size overflow"),
    };
    if end > memory.len() {
        bail!("pointer out of bounds")
    }
    Ok(ptr)
}

struct Types {
    params: Box<[Type]>,
    result: Type,
}

struct DynamicContext<F> {
    func: F,
    types: Types,
}

extern "C" fn dynamic_entrypoint<
    T,
    F: Fn(StoreContextMut<'_, T>, &[Val]) -> Result<Val> + Send + Sync + 'static,
>(
    cx: *mut VMOpaqueContext,
    data: *mut u8,
    flags: InstanceFlags,
    memory: *mut VMMemoryDefinition,
    realloc: *mut VMCallerCheckedAnyfunc,
    string_encoding: StringEncoding,
    storage: *mut ValRaw,
    storage_len: usize,
) {
    let data = data as *const DynamicContext<F>;
    unsafe {
        handle_result(|| {
            call_host_dynamic::<T, _>(
                &(*data).types,
                cx,
                flags,
                memory,
                realloc,
                string_encoding,
                std::slice::from_raw_parts_mut(storage, storage_len),
                |store, values| ((*data).func)(store, values),
            )
        })
    }
}
