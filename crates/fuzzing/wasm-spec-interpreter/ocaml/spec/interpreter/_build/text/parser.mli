type token =
  | LPAR
  | RPAR
  | NAT of (string)
  | INT of (string)
  | FLOAT of (string)
  | STRING of (string)
  | VAR of (string)
  | NUM_TYPE of (Types.num_type)
  | VEC_TYPE of (Types.vec_type)
  | VEC_SHAPE of (V128.shape)
  | FUNCREF
  | EXTERNREF
  | EXTERN
  | MUT
  | UNREACHABLE
  | NOP
  | DROP
  | SELECT
  | BLOCK
  | END
  | IF
  | THEN
  | ELSE
  | LOOP
  | BR
  | BR_IF
  | BR_TABLE
  | CALL
  | CALL_INDIRECT
  | RETURN
  | LOCAL_GET
  | LOCAL_SET
  | LOCAL_TEE
  | GLOBAL_GET
  | GLOBAL_SET
  | TABLE_GET
  | TABLE_SET
  | TABLE_SIZE
  | TABLE_GROW
  | TABLE_FILL
  | TABLE_COPY
  | TABLE_INIT
  | ELEM_DROP
  | MEMORY_SIZE
  | MEMORY_GROW
  | MEMORY_FILL
  | MEMORY_COPY
  | MEMORY_INIT
  | DATA_DROP
  | LOAD of (int option -> Memory.offset -> Ast.instr')
  | STORE of (int option -> Memory.offset -> Ast.instr')
  | OFFSET_EQ_NAT of (string)
  | ALIGN_EQ_NAT of (string)
  | CONST of (string Source.phrase -> Ast.instr' * Values.num)
  | UNARY of (Ast.instr')
  | BINARY of (Ast.instr')
  | TEST of (Ast.instr')
  | COMPARE of (Ast.instr')
  | CONVERT of (Ast.instr')
  | REF_NULL
  | REF_FUNC
  | REF_EXTERN
  | REF_IS_NULL
  | VEC_LOAD of (int option -> Memory.offset -> Ast.instr')
  | VEC_STORE of (int option -> Memory.offset -> Ast.instr')
  | VEC_LOAD_LANE of (int option -> Memory.offset -> int -> Ast.instr')
  | VEC_STORE_LANE of (int option -> Memory.offset -> int -> Ast.instr')
  | VEC_CONST of (V128.shape -> string Source.phrase list -> Source.region -> Ast.instr' * Values.vec)
  | VEC_UNARY of (Ast.instr')
  | VEC_BINARY of (Ast.instr')
  | VEC_TERNARY of (Ast.instr')
  | VEC_TEST of (Ast.instr')
  | VEC_SHIFT of (Ast.instr')
  | VEC_BITMASK of (Ast.instr')
  | VEC_SHUFFLE
  | VEC_EXTRACT of (int -> Ast.instr')
  | VEC_REPLACE of (int -> Ast.instr')
  | FUNC
  | START
  | TYPE
  | PARAM
  | RESULT
  | LOCAL
  | GLOBAL
  | TABLE
  | ELEM
  | MEMORY
  | DATA
  | DECLARE
  | OFFSET
  | ITEM
  | IMPORT
  | EXPORT
  | MODULE
  | BIN
  | QUOTE
  | SCRIPT
  | REGISTER
  | INVOKE
  | GET
  | ASSERT_MALFORMED
  | ASSERT_INVALID
  | ASSERT_SOFT_INVALID
  | ASSERT_UNLINKABLE
  | ASSERT_RETURN
  | ASSERT_TRAP
  | ASSERT_EXHAUSTION
  | NAN of (Script.nan)
  | INPUT
  | OUTPUT
  | EOF
  | VEC_SPLAT of (Ast.instr')

val script :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Script.script
val script1 :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Script.script
val module1 :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Script.var option * Script.definition
