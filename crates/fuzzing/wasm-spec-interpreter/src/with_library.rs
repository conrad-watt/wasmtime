//! Interpret WebAssembly modules using the OCaml spec interpreter.
//! ```
//! # use wasm_spec_interpreter::{Value, interpret};
//! let module = wat::parse_file("tests/add.wat").unwrap();
//! let parameters = vec![Value::I32(42), Value::I32(1)];
//! let results = interpret(&module, Some(parameters)).unwrap();
//! assert_eq!(results, &[Value::I32(43)]);
//! ```
use crate::Value;
use ocaml_interop::{OCamlRuntime, ToOCaml, BoxRoot};
use once_cell::sync::Lazy;
use std::sync::Mutex;

static INTERPRET: Lazy<Mutex<()>> = Lazy::new(|| Mutex::new(()));

/// Interpret the first function in the passed WebAssembly module (in Wasm form,
/// currently, not WAT), optionally with the given parameters. If no parameters
/// are provided, the function is invoked with zeroed parameters.
pub fn interpret_legacy(module: &[u8], opt_parameters: Option<Vec<Value>>) -> Result<Vec<Value>, String> {
    // The OCaml runtime is not re-entrant
    // (https://ocaml.org/manual/intfc.html#ss:parallel-execution-long-running-c-code).
    // We need  to make sure that only one Rust thread is executing at a time
    // (using this lock) or we can observe `SIGSEGV` failures while running
    // `cargo test`.
    let _lock = INTERPRET.lock().unwrap();
    // Here we use an unsafe approach to initializing the `OCamlRuntime` based
    // on the discussion in https://github.com/tezedge/ocaml-interop/issues/35.
    // This was the recommendation to resolve seeing errors like `boxroot is not
    // setup` followed by a `SIGSEGV`; this is similar to the testing approach
    // in
    // https://github.com/tezedge/ocaml-interop/blob/master/testing/rust-caller/src/lib.rs
    // and is only as safe as the OCaml code running underneath.
    OCamlRuntime::init_persistent();
    let ocaml_runtime = unsafe { OCamlRuntime::recover_handle() };
    // Parse and execute, returning results converted to Rust.
    let module = module.to_boxroot(ocaml_runtime);

    let opt_parameters = opt_parameters.to_boxroot(ocaml_runtime);
    let results = ocaml_bindings::interpret_legacy(ocaml_runtime, &module, &opt_parameters);
    results.to_rust(ocaml_runtime)
}

// Here we declare which functions we will use from the OCaml library. See
// https://docs.rs/ocaml-interop/0.8.4/ocaml_interop/index.html#example.
mod ocaml_bindings {
    use super::*;
    use ocaml_interop::{
        impl_conv_ocaml_variant, ocaml, FromOCaml, OCaml, OCamlBytes, OCamlInt32, OCamlInt64,
        OCamlList,
    };

    // Using this macro converts the enum both ways: Rust to OCaml and OCaml to
    // Rust. See
    // https://docs.rs/ocaml-interop/0.8.4/ocaml_interop/macro.impl_conv_ocaml_variant.html.
    impl_conv_ocaml_variant! {
        Value {
            Value::I32(i: OCamlInt32),
            Value::I64(i: OCamlInt64),
            Value::F32(i: OCamlInt32),
            Value::F64(i: OCamlInt64),
            Value::V128(i: OCamlBytes),
        }
    }

    /// Represents a WebAssembly instance from the OCaml interpreter side.
    pub struct OCamlInstance {
        repr: BoxRoot<OCamlInstance>,
    }
    unsafe impl FromOCaml<OCamlInstance> for OCamlInstance {
        fn from_ocaml(v: OCaml<OCamlInstance>) -> Self {
            Self {
                repr: BoxRoot::new(v),
            }
        }
    }
    unsafe impl ToOCaml<OCamlInstance> for OCamlInstance {
        fn to_ocaml<'a>(&self, cr: &'a mut OCamlRuntime) -> OCaml<'a, OCamlInstance> {
            BoxRoot::get(&self.repr, cr)
        }
    }

    /// Represents a WebAssembly export from the OCaml interpreter side.
    #[allow(dead_code)]
    pub enum OCamlExportValue {
        Global(Value),
        Memory(Vec<u8>),
    }
    // Using this macro converts the enum both ways.
    impl_conv_ocaml_variant! {
        OCamlExportValue {
            OCamlExportValue::Global(i: Value),
            OCamlExportValue::Memory(i: OCamlBytes),
        }
    }

    // These functions must be exposed from OCaml with:
    //   `Callback.register "interpret" interpret`
    //
    // In Rust, this function becomes:
    //   `pub fn interpret(_: &mut OCamlRuntime, ...: OCamlRef<...>) -> BoxRoot<...>;`
    //
    // instantiate: clear the global store, and instantiate a new Wasm module from bytes
    // interpret: given an instance, call the function exported at "name"
    // interpret_legacy: starting from bytes, instantiate and execute the first exported function
    // export: given an instance, get the value of the export at "name"
    ocaml! {
        pub fn instantiate(module: OCamlBytes) -> Result<OCamlInstance, String>;
        pub fn interpret(instance: OCamlInstance, name: String, params: Option<OCamlList<Value>>) -> Result<OCamlList<Value>, String>;
        pub fn interpret_legacy(module: OCamlBytes, params: Option<OCamlList<Value>>) -> Result<OCamlList<Value>, String>;
        pub fn export(instance: OCamlInstance, name: String) -> Result<OCamlExportValue, String>;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn multiple() {
        let module = wat::parse_file("tests/add.wat").unwrap();

        let parameters1 = Some(vec![Value::I32(42), Value::I32(1)]);
        let results1 = interpret_legacy(&module, parameters1.clone()).unwrap();

        let parameters2 = Some(vec![Value::I32(1), Value::I32(42)]);
        let results2 = interpret_legacy(&module, parameters2.clone()).unwrap();

        assert_eq!(results1, results2);

        let parameters3 = Some(vec![Value::I32(20), Value::I32(23)]);
        let results3 = interpret_legacy(&module, parameters3.clone()).unwrap();

        assert_eq!(results2, results3);
    }

    #[test]
    fn oob() {
        let module = wat::parse_file("tests/oob.wat").unwrap();
        let results = interpret_legacy(&module, None);
        assert_eq!(
            results,
            Err("Error(_, \"(Isabelle) trap: load\")".to_string())
        );
    }

    #[test]
    fn simd_not() {
        let module = wat::parse_file("tests/simd_not.wat").unwrap();

        let parameters = Some(vec![Value::V128(vec![
            0, 255, 0, 0, 255, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0,
        ])]);
        let results = interpret_legacy(&module, parameters.clone()).unwrap();

        assert_eq!(
            results,
            vec![Value::V128(vec![
                255, 0, 255, 255, 0, 255, 255, 255, 255, 0, 255, 255, 255, 255, 255, 255
            ])]
        );
    }

    // See issue https://github.com/bytecodealliance/wasmtime/issues/4671.
    #[test]
    fn order_of_params_legacy() {
        let module = wat::parse_file("tests/shr_s.wat").unwrap();

        let parameters = Some(vec![Value::I32(1795123818), Value::I32(-2147483648)]);
        let results = interpret_legacy(&module, parameters.clone()).unwrap();

        assert_eq!(results, vec![Value::I32(1795123818)]);
    }

    // See issue https://github.com/bytecodealliance/wasmtime/issues/4671.
    #[test]
    fn order_of_params() {
        use ocaml_bindings::*;
        use ocaml_interop::*;
        let module = wat::parse_file("tests/shr_s.wat").unwrap();
        let mut ocaml_runtime = OCamlRuntime::init();

        // Instantiate the module to a Rust `OCamlInstance`.
        let module = module.to_boxroot(&mut ocaml_runtime);
        let instance: BoxRoot<Result<OCamlInstance, String>> =
            instantiate(&mut ocaml_runtime, &module);
        let instance: Result<OCamlInstance, String> = instance.to_rust(&mut ocaml_runtime);
        let instance: OCamlInstance = instance.unwrap();
        let instance: BoxRoot<OCamlInstance> = instance.to_boxroot(&mut ocaml_runtime);

        // Call function "test".
        let parameters = Some(vec![Value::I32(1795123818), Value::I32(-2147483648)]);
        let parameters = parameters.to_boxroot(&mut ocaml_runtime);
        let func_name: String = "test".into();
        let func_name: BoxRoot<String> = func_name.to_boxroot(&mut ocaml_runtime);
        let results: BoxRoot<Result<OCamlList<Value>, String>> =
            interpret(&mut ocaml_runtime, &instance, &func_name, &parameters);

        // Convert results.
        let results: Result<Vec<Value>, String> = results.to_rust(&ocaml_runtime);
        let results = results.unwrap();

        assert_eq!(results, vec![Value::I32(1795123818)]);
    }

    #[test]
    fn result_roundtrip() {
        // This test just checks that we can indeed convert back and forth from
        // `Result<...>` types.
        use ocaml_interop::*;
        let mut or = OCamlRuntime::init();
        let x0: Result<&[u8], String> = Ok(b".....");
        // We can box the value in the OCaml runtime, resulting in a copy of the
        // bytes--see `alloc_bytes` in `impl ToOCaml<OCamlBytes> for &[u8]`
        // (`to_ocaml.rs`).
        let x1: BoxRoot<Result<OCamlBytes, String>> = x0.to_boxroot(&mut or);
        // Then we can return the value to Rust with another copy--see
        // `extend_from_slice` in `impl FromOCaml<OCamlBytes> for Vec<u8>`
        // (`from_ocaml.rs`).
        let _x2: Result<Vec<u8>, String> = x1.to_rust(&mut or);
    }

    #[test]
    fn instantiate_load_store() {
        use ocaml_bindings::*;
        use ocaml_interop::*;
        let module = wat::parse_file("tests/memory.wat").unwrap();
        let mut ocaml_runtime = OCamlRuntime::init();

        // Instantiate the module to a Rust `OCamlInstance`.
        let module = module.to_boxroot(&mut ocaml_runtime);
        let instance: BoxRoot<Result<OCamlInstance, String>> =
            instantiate(&mut ocaml_runtime, &module);
        let instance: Result<OCamlInstance, String> = instance.to_rust(&mut ocaml_runtime);
        let instance: OCamlInstance = instance.unwrap();
        let instance: BoxRoot<OCamlInstance> = instance.to_boxroot(&mut ocaml_runtime);

       // Call function to store 42 at offset 4.
        let parameters = Some(vec![Value::I32(4), Value::I32(42)]);
        let parameters = parameters.to_boxroot(&mut ocaml_runtime);
        let func_name: String = "store_i32".into();
        let func_name: BoxRoot<String> = func_name.to_boxroot(&mut ocaml_runtime);
        let _results: BoxRoot<Result<OCamlList<Value>, String>> =
            interpret(&mut ocaml_runtime, &instance, &func_name, &parameters);

       // Call function to load i32 at offset 4.
        let parameters = Some(vec![Value::I32(4)]);
        let parameters = parameters.to_boxroot(&mut ocaml_runtime);
        let func_name: String = "load_i32".into();
        let func_name: BoxRoot<String> = func_name.to_boxroot(&mut ocaml_runtime);
        let results: BoxRoot<Result<OCamlList<Value>, String>> =
            interpret(&mut ocaml_runtime, &instance, &func_name, &parameters);

        // Convert results.
        let results: Result<Vec<Value>, String> = results.to_rust(&ocaml_runtime);
        let results = results.unwrap();

        // Check stored value was retrieved.
        assert_eq!(results, vec![Value::I32(42)]);

        // Retrieve the memory exported at "mem".
        let export_name: String = "mem".into();
        let export_name: BoxRoot<String> = export_name.to_boxroot(&mut ocaml_runtime);
        let export: BoxRoot<Result<OCamlExportValue, String>> =
            export(&mut ocaml_runtime, &instance, &export_name);
        let export: Result<OCamlExportValue, String> = export.to_rust(&mut ocaml_runtime);

        // Check 32-bit le value at byte offset 4 of mem is 42.
        match export.unwrap() {
            OCamlExportValue::Global(i) => panic!("incorrect export"),
            OCamlExportValue::Memory(i) => {
            let arr : [u8; 4] = i.chunks(4).nth(1).unwrap().try_into().unwrap();
            let v = i32::from_le_bytes(arr);
            assert_eq!(v, 42);
            },
        }
    }
}
