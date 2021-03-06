(************************************************************************************)
(*  BSD 2-Clause License                                                            *)
(*                                                                                  *)
(*  Cerberus                                                                        *)
(*                                                                                  *)
(*  Copyright (c) 2017                                                              *)
(*    Victor Gomes                                                                  *)
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

(* Based on Jacques-Henri Jourdan and Francois Pottier TOPLAS 2017:
   "A simple, possibly correct LR parser for C11" *)

open Cerb_frontend

type context
val save_context: unit -> context
val restore_context: context -> unit

val declare_typedefname: string -> unit
val declare_varname: string -> unit
val is_typedefname: string -> bool

type declarator

val identifier: declarator -> string
val cabs_of_declarator: declarator -> Cabs.declarator

val pointer_decl: Cabs.pointer_declarator -> declarator -> declarator
val identifier_decl: Annot.attributes -> Symbol.identifier -> declarator
val declarator_decl: declarator -> declarator
val array_decl: Cabs.array_declarator -> declarator -> declarator
val fun_decl: Cabs.parameter_type_list -> context -> declarator -> declarator
val fun_ids_decl: Symbol.identifier list -> context -> declarator -> declarator

val reinstall_function_context: declarator -> unit
val create_function_definition: Location_ocaml.t -> ((((Symbol.identifier option * Symbol.identifier) * (((Location_ocaml.t * string) list) option)) list) list) option -> Cabs.specifiers -> declarator -> Cabs.cabs_statement -> Cabs.declaration list option -> Cabs.function_definition
