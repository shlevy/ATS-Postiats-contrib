//
(*
** For writing ATS code that translates into Python
*)
//
(* ****** ****** *)
//
(*
The MIT License (MIT)

Copyright (c) 2014 Hongwei Xi

Permission is hereby granted,  free of charge,  to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use,  copy,  modify, merge, publish, distribute, sublicense,
and/or  sell  copies  of  the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)
(* ****** ****** *)
//
// HX-2014-08:
// prefix for external names
//
#define
ATS_EXTERN_PREFIX "ats2pypre_"
//
(* ****** ****** *)
//
typedef
cfun1 (a:t0p, b:t0p) = (a) -<cloref1> b
typedef
cfun2 (a1:t0p, a2:t0p, b:t0p) = (a1, a2) -<cloref1> b
//
stadef cfun = cfun1
stadef cfun = cfun2
//
(* ****** ****** *)

abstype PYfile

(* ****** ****** *)
//
// HX-2014-08:
// invariant constructors!
//
abstype PYlist (a:t@ype)
abstype PYset  (a:t@ype)
abstype PYdict (a:t@ype)
//
(* ****** ****** *)
//
fun
print_obj{a:t@ype}(obj: a): void = "mac#%"
fun
println_obj{a:t@ype}(obj: a): void = "mac#%"
//
(* ****** ****** *)

fun print_newline ((*void*)): void = "mac#%"
fun prerr_newline ((*void*)): void = "mac#%"
fun fprint_newline (out: PYfile): void = "mac#%"

(* ****** ****** *)

(* end of [basics_py.sats] *)
