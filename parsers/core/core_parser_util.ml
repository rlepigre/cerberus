(************************************************************************************)
(*  BSD 2-Clause License                                                            *)
(*                                                                                  *)
(*  Cerberus                                                                        *)
(*                                                                                  *)
(*  Copyright (c) 2011-2020                                                         *)
(*    Kayvan Memarian                                                               *)
(*    Victor Gomes                                                                  *)
(*    Justus Matthiesen                                                             *)
(*    Peter Sewell                                                                  *)
(*    Kyndylan Nienhuis                                                             *)
(*    Stella Lau                                                                    *)
(*    Jean Pichon-Pharabod                                                          *)
(*    Christopher Pulte                                                             *)
(*    Rodolphe Lepigre                                                              *)
(*    James Lingard                                                                 *)
(*                                                                                  *)
(*  All rights reserved.                                                            *)
(*                                                                                  *)
(*  Redistribution and use in source and binary forms, with or without              *)
(*  modification, are permitted provided that the following conditions are met:     *)
(*                                                                                  *)
(*  1. Redistributions of source code must retain the above copyright notice, this  *)
(*     list of conditions and the following disclaimer.                             *)
(*                                                                                  *)
(*  2. Redistributions in binary form must reproduce the above copyright notice,    *)
(*     this list of conditions and the following disclaimer in the documentation    *)
(*     and/or other materials provided with the distribution.                       *)
(*                                                                                  *)
(*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"     *)
(*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE       *)
(*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE  *)
(*  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE    *)
(*  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL      *)
(*  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR      *)
(*  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER      *)
(*  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,   *)
(*  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE   *)
(*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.            *)
(************************************************************************************)

open Cerb_frontend

type _sym =
  string * (Lexing.position * Lexing.position)

let _sym_compare (str1, _) (str2, _) =
  compare str1 str2

type mode =
  | StdMode
  | ImplORFileMode

type parsed_core_file =
  Symbol.sym (* main symbol *) *
  (Symbol.sym * Core.core_base_type * unit Core.expr) list (* globals *) *
  unit Core.fun_map (* fun map *) *
  (Symbol.sym, Ctype.tag_definition) Pmap.map (* tagDefs *)

(* Type of Core parser outputs *)
type result =
  | Rfile of parsed_core_file
  | Rstd  of (string, Symbol.sym) Pmap.map (* Map of ailnames *) * unit Core.fun_map
  | Rimpl of Core.impl (* * unit Core.fun_map *)

exception Core_error of (Location_ocaml.t * Errors.core_parser_cause)

type token =
  | SHORT
  | INT
  | LONG
  | LONG_LONG
  | BOOL
  | SIGNED
  | UNSIGNED
  | FLOAT
  | DOUBLE
  | LONG_DOUBLE
  | CHAR
  | ICHAR
  | VOID
  
  | INT8_T
  | INT16_T
  | INT32_T
  | INT64_T
  | UINT8_T
  | UINT16_T
  | UINT32_T
  | UINT64_T

  | INTPTR_T
  | INTMAX_T
  | UINTPTR_T
  | UINTMAX_T
  
  | SIZE_T
  | PTRDIFF_T
  
  | ATOMIC
  | STRUCT (* TODO *)
  | UNION (* TODO *)
  | ENUM (* TODO *)
  | WCHAR_T (* TODO *)
  | CHAR16_T (* TODO *)
  | CHAR32_T (* TODO *)
  | INTEGER
  | FLOATING
  | BOOLEAN
  | POINTER
  | CTYPE
  | CFUNCTION
  | UNIT
  | UNIT_VALUE
  | EFF
  | TRUE
  | FALSE
  | NOT
  | UNDEF
  | ERROR
  | SKIP
  | LET
  | IN
  | IF
  | THEN
  | ELSE
  | UNSEQ
  | WEAK
  | STRONG
  | ATOM
  | SAVE (* TODO *)
  | RUN (* TODO *)
  | RAISE (* TODO *)
  | REGISTER (* TODO *)
(*
  | TRY
  | WITH
*)

  | INDET
  | BOUND
  | CREATE
  | CREATE_READONLY
  | ALLOC
  | FREE
  | KILL
  | STORE
  | STORE_LOCK
  | LOAD
  | RMW
  | FENCE
(*  | COMPARE_EXCHANGE_STRONG *)
  | DEF
  | GLOB
  | FUN
  | PROC
  | END
  | SEQ_CST
  | RELAXED
  | RELEASE
  | ACQUIRE
  | CONSUME
  | ACQ_REL
  | IS_SCALAR
  | IS_INTEGER
  | IS_SIGNED
  | IS_UNSIGNED
  | IS_UNSPEC
  | ARE_COMPATIBLE
  | UNSPECIFIED
  
  | STRING of string
  | CSTRING of string
  
  | SYM of _sym
  | IMPL of Implementation.implementation_constant
  | UB of Undefined.undefined_behaviour
  | INT_CONST of Nat_big_num.num
  
  | SQUOTE
  
  | CASE
  | OF
  
  | EQ_GT

  | PLUS
  | MINUS
  | STAR
  | SLASH
  | REM_T
  | REM_F
  | CARET
  | EQ
  | GT
  | LT
  | GE
  | LE
  | SLASH_BACKSLASH
  | BACKSLASH_SLASH
  | NEG
  | UNDERSCORE
  | PIPE
  | LPAREN
  | RPAREN
  | LBRACKET
  | RBRACKET
  | LBRACE
  | RBRACE
  | DOT
  | DOTS
  | SEMICOLON
  | COMMA
  | COLON
  | COLON_EQ
  | EOF
  
  | PAR
  | ND
  | WAIT (* TODO *)
  | ARRAY_SHIFT
  | MEMBER_SHIFT
  
  (* integer values *)
  | IVMAX
  | IVMIN
  | IVSIZEOF
  | IVALIGNOF
  | IVCOMPL
  | IVAND
  | IVOR
  | IVXOR
  | CCALL
  | PCALL
  | CFUNCTION_VALUE
  | ARRAYCTOR

  | COLON_COLON
  | BRACKETS
  | ARRAY
  | LOADED
  | STORABLE
  | SPECIFIED
  
  | PURE
  
  | MEMOP
  | MEMOP_OP of Mem_common.memop
  
  | AILNAME
  
  | FVFROMINT
  | IVFROMFLOAT
  | NULL
  | BUILTIN
