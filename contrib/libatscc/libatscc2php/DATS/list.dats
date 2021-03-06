(*
** For writing ATS code
** that translates into PHP
*)

(* ****** ****** *)

#define ATS_DYNLOADFLAG 0

(* ****** ****** *)
//
// HX-2014-08:
// prefix for external names
//
#define
ATS_EXTERN_PREFIX "ats2phppre_"
#define
ATS_STATIC_PREFIX "_ats2phppre_list_"
//
(* ****** ****** *)
//
#include
"share/atspre_define.hats"
//
(* ****** ****** *)
//
staload UN =
"prelude/SATS/unsafe.sats"
//
(* ****** ****** *)
//
staload "./../SATS/integer.sats"
//
(* ****** ****** *)
//
staload "./../SATS/print.sats"
staload "./../SATS/filebas.sats"
//
(* ****** ****** *)

staload "./../SATS/list.sats"

(* ****** ****** *)
//
#include "{$LIBATSCC}/DATS/list.dats"
//
(* ****** ****** *)
//
implement
{a}(*tmp*)
print_list (xs) = fprint_list<a> (STDOUT, xs)
implement
{a}(*tmp*)
print_list_sep
  (xs, sep) = fprint_list_sep<a> (STDOUT, xs, sep)
//
(* ****** ****** *)

(* end of [list.dats] *)
