(* This module exposes an [interpret] function to Rust. It wraps several
different calls from the WebAssembly specification interpreter in a way that we
can access across the FFI boundary. To understand this better, see:
 - the OCaml manual documentation re: calling OCaml from C,
 https://ocaml.org/manual/intfc.html#s%3Ac-advexample
 - the [ocaml-interop] example,
 https://github.com/tezedge/ocaml-interop/blob/master/testing/rust-caller/ocaml/callable.ml
*)

(** Enumerate the types of values we pass across the FFI boundary. This must
match `Value` in `src/lib.rs` *)
type ffi_value =
  | I32 of int32
  | I64 of int64
  | F32 of int32
  | F64 of int64
  | V128 of Bytes.t

(** An opaque reference to the instance used by the interpreter. This is
currently using a garbage type (TODO). *)
type ffi_instance = int

(** Enumerate the kinds of things the interpreter can export. *)
type ffi_export =
  | Memory of Bytes.t
  | Global of ffi_value

(* Here we access the WebAssembly specification interpreter; this must be linked
in. *)
open Wasm
open Wasm.WasmRef_Isa_m.WasmRef_Isa

(** Helper for converting the FFI values to their spec interpreter type. *)
let convert_to_wasm (v: ffi_value) : v = match v with
| I32 n -> V_num (ConstInt32 (I32_impl_abs n))
| I64 n -> V_num (ConstInt64 (I64_impl_abs n))
| F32 n -> V_num (ConstFloat32 (F32.of_bits n))
| F64 n -> V_num (ConstFloat64 (F64.of_bits n))
| V128 n -> V_vec (ConstVec128 (V128.of_bits (Bytes.to_string n)))

(** Helper for converting the spec interpreter values to their FFI type. *)
let convert_from_wasm (v: v) : ffi_value = match v with
| V_num ((ConstInt32 (I32_impl_abs n))) -> I32 n
| V_num ((ConstInt64 (I64_impl_abs n))) -> I64 n
| V_num ((ConstFloat32 n)) -> F32 (F32.to_bits n)
| V_num ((ConstFloat64 n)) -> F64 (F64.to_bits n)
| V_vec ((ConstVec128 n)) -> V128 (Bytes.of_string (V128.to_bits n))

(** Parse the given WebAssembly module binary into an Ast.module_. At some point
in the future this should also be able to parse the textual form (TODO). *)
let parse bytes =
  (* Optionally, use Bytes.unsafe_to_string here to avoid the copy *)
  let bytes_as_str = Bytes.to_string bytes in
  (Decode.decode "default" bytes_as_str)

(** Construct an instance from a sequence of WebAssembly bytes. *)
let instantiate module_bytes = Ok(42)

(** Retrieve an export by name from a WebAssembly instance. *)
let export instance name =
  print_endline "here"; Error("no export found")

(** Interpret the first exported function and return the result. Use provided
parameters if they exist, otherwise use default (zeroed) values. *)
let interpret_exn module_bytes opt_params =
  let opt_params_ = Option.map (List.rev_map convert_to_wasm) opt_params in
  let module_ = parse module_bytes in
  let m_isa = Ast_convert.convert_module (module_.it) in
  let fuel = Z.of_string "4611686018427387904" in
  let max_call_depth = Z.of_string "300" in
  (match run_fuzz (nat_of_integer fuel) (nat_of_integer max_call_depth) (make_empty_store_m ()) m_isa [] opt_params_ () with
  | (s', RValue vs_isa') -> List.rev_map convert_from_wasm vs_isa'
  | (s', RTrap str) -> raise (Eval.Trap (Source.no_region, "(Isabelle) trap: " ^ str))
  | (s', (RCrash (Error_exhaustion str))) -> raise (Eval.Exhaustion (Source.no_region, "(Isabelle) call stack exhausted"))
  | (s', (RCrash (Error_invalid str))) -> raise (Eval.Crash (Source.no_region, "(Isabelle) error: " ^ str))
  | (s', (RCrash (Error_invariant str))) -> raise (Eval.Crash (Source.no_region, "(Isabelle) error: " ^ str))
  )

let interpret module_bytes opt_params =
  try Ok(interpret_exn module_bytes opt_params) with
  | _ as e -> Error(Printexc.to_string e)

let () =
  Callback.register "instantiate" instantiate;
  Callback.register "interpret" interpret;
  Callback.register "export" export;
