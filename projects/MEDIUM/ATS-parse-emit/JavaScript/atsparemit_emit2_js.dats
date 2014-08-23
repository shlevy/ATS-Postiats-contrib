(* ****** ****** *)
//
// ATS-parse-emit-js
//
(* ****** ****** *)
//
// HX-2014-08-20: start
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
staload
UN = "prelude/SATS/unsafe.sats"
//
(* ****** ****** *)
//
staload "./atsparemit.sats"
staload "./atsparemit_syntax.sats"
//
(* ****** ****** *)
//
staload "./atsparemit_emit.sats"
//
(* ****** ****** *)
//
staload "./atsparemit_typedef.dats"
//
(* ****** ****** *)
//
extern
fun
emit_tmpdeclst_initize
  (out: FILEref, tds: tmpdeclst): void
//
implement
emit_tmpdeclst_initize
  (out, tds) = let
//
fun auxlst
(
  out: FILEref, tds: tmpdeclst
) : void =
(
case+ tds of
| list_nil () => ()
| list_cons (td, tds) =>
  (
    case+ td.tmpdec_node of
    | TMPDECnone
        (tmp) => auxlst (out, tds)
    | TMPDECsome
        (tmp, _) => let
        val () = emit_nspc (out, 2(*ind*))
        val () =
        (
          emit_text (out, "var "); emit_i0de (out, tmp); emit_ENDL (out)
        ) (* end of [val] *)
      in
        auxlst (out, tds)
      end // end of [TMPDECsome]
  ) (* end of [list_cons] *)
)
//
in
  auxlst (out, tds)
end // end of [emit_tmpdeclst_initize]
//
(* ****** ****** *)
//
extern
fun
the_f0arglst_get (): f0arglst
extern
fun
the_f0arglst_set (f0as: f0arglst): void
//
(* ****** ****** *)
//
extern
fun
the_tmpdeclst_get (): tmpdeclst
extern
fun
the_tmpdeclst_set (tds: tmpdeclst): void
//
(* ****** ****** *)
//
extern
fun
the_funbodylst_get (): instrlst
extern
fun
the_funbodylst_set (inss: instrlst): void
//
(* ****** ****** *)
//
extern
fun
the_branchlablst_get (): labelist
extern
fun
the_branchlablst_set (tls: labelist): void
extern
fun
the_branchlablst_unset ((*void*)): void
//
(* ****** ****** *)

local
//
val the_f0arglst = ref<f0arglst> (list_nil)
val the_tmpdeclst = ref<tmpdeclst> (list_nil)
//
val the_funbodylst = ref<instrlst> (list_nil)
//
// HX: this is a stack:
//
val the_branchlablstlst = ref<List0(labelist)> (list_nil)
//
in (* in-of-local *)

implement
the_f0arglst_get () = !the_f0arglst
implement
the_f0arglst_set (xs) = !the_f0arglst := xs

implement
the_tmpdeclst_get () = !the_tmpdeclst
implement
the_tmpdeclst_set (xs) = !the_tmpdeclst := xs

implement
the_funbodylst_get () = !the_funbodylst
implement
the_funbodylst_set (xs) = !the_funbodylst := xs

implement
the_branchlablst_get
(
) = let
//
val xss = !the_branchlablstlst
//
in
//
case- xss of list_cons (xs, _) => xs
//
end // end of [the_branchlablst_get]

implement
the_branchlablst_set
(
  xs
) = let
//
val xss = !the_branchlablstlst
//
in
  !the_branchlablstlst := list_cons (xs, xss)
end // end of [the_branchlablst_set]

implement
the_branchlablst_unset
(
) = let
//
val xss = !the_branchlablstlst
//
in
//
case- xss of
| list_cons (_, xss) => !the_branchlablstlst := xss
//
end // end of [the_branchlablst_unset]

end // end of [local]

(* ****** ****** *)
//
extern
fun
funlab_get_index (fl: label): int
extern
fun
tmplab_get_index (lab: label): int
//
(* ****** ****** *)

implement
funlab_get_index
  (fl0) = let
//
val n0 = fl0.i0de_sym
//
fun
auxlst
(
  xs: instrlst, i: int
) : int = (
//
case+ xs of
| list_nil () => ~1(*error*)
| list_cons (x, xs) =>
  (
    case+ x.instr_node of
    | ATSfunbodyseq _ => let
        val fl = funbodyseq_get_funlab (x)
      in
        if n0 = fl.i0de_sym then i else auxlst (xs, i+1)
      end // end of [ATSfunbodyseq]
    | _ (*non-ATSfunbody*) => auxlst (xs, i)
  ) (* end of [list_cons] *)
//
) (* end of [auxlst] *)
//
in
  auxlst (the_funbodylst_get(), 1)
end // end of [funlab_get_index]

(* ****** ****** *)

implement
tmplab_get_index
  (lab0) = let
//
val n0 = lab0.i0de_sym
//
fun
auxlst
(
  xs: labelist, i: int
) : int =
(
case+ xs of
| list_nil () => ~1(*error*)
| list_cons (x, xs) =>
    if n0 = x.i0de_sym then i else auxlst (xs, i+1)
  // end of [list_cons]
)
//
in
  auxlst (the_branchlablst_get(), 1)
end // end of [tmplab_get_index]

(* ****** ****** *)
//
fun
emit_funlab_index
 (out: FILEref, fl: label): void =
 emit_int (out, funlab_get_index (fl))
//
fun
emit_tmplab_index
 (out: FILEref, lab: label): void =
 emit_int (out, tmplab_get_index (lab))
//
(* ****** ****** *)
//
extern
fun emit2_instr
  (out: FILEref, ind: int, ins: instr) : void
extern
fun emit2_instr_ln
  (out: FILEref, ind: int, ins: instr) : void
//
extern
fun emit2_instrlst
  (out: FILEref, ind: int, inss: instrlst) : void
//
(* ****** ****** *)
//
extern
fun emit2_branchseqlst
  (out: FILEref, ind: int, inss: instrlst): void
//
(* ****** ****** *)
//
extern
fun emit2_ATSfunbodyseq
  (out: FILEref, ind: int, ins: instr) : void
//
extern
fun emit2_ATSINSmove_con1
  (out: FILEref, ind: int, ins: instr) : void
extern
fun emit2_ATSINSmove_boxrec
  (out: FILEref, ind: int, ins: instr) : void
//
(* ****** ****** *)
//
// HX-2014-08:
// this one should not be used for
// emitting multiple-line instructions
//
implement
emit_instr
  (out, ins) = emit2_instr (out, 0(*ind*), ins)
//
(* ****** ****** *)

implement
emit2_instr
  (out, ind, ins0) = let
in
//
case+
ins0.instr_node of
//
| ATSif
  (
    d0e, inss, inssopt
  ) => let
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "if ")
    val () = emit_LPAREN (out)
    val () = emit_d0exp (out, d0e)
    val () = emit_RPAREN (out)
    val () = emit_text (out, " {\n")
    val () = emit2_instrlst (out, ind+2, inss)
    val () = emit_nspc (out, ind)
  in
    case+ inssopt of
    | None _ =>
      {
        val () = emit_text (out, "} // endif")
      } (* end of [None] *)
    | Some (inss) =>
      {
        val () =
          emit_text (out, "} else {\n")
        val () =
          emit2_instrlst (out, ind+2, inss)
        val () = emit_nspc (out, ind)
        val ((*closing*)) = emit_text (out, "} // endif")
      } (* end of [Some] *)
  end // end of [ATSif]
//
| ATSifthen (d0e, inss) =>
  {
//
    val-list_cons (ins, _) = inss
//
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "if(")
    val () = emit_d0exp (out, d0e)
    val () = emit_text (out, ") ")
    val () = emit_instr (out, ins)
  }
//
| ATSifnthen (d0e, inss) =>
  {
//
    val-list_cons (ins, _) = inss
//
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "if(!")
    val () = emit_d0exp (out, d0e)
    val ((*closing*)) = emit_text (out, ") ")
    val () = emit_instr (out, ins)
  }
//
| ATSbranchseq (inss) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "// ATSbranchseq(...)")
  }
//
| ATScaseofseq (inss) =>
  {
//
    val tls =
      caseofseq_get_tmplablst (ins0)
    // end of [val]
    val () = the_branchlablst_set (tls)
//
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "// ATScaseofseq_beg")
    val () = emit_ENDL (out)
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "tmplab_js = 1\n")
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "while(true) {\n")
    val () = emit_nspc (out, ind+2)
    val () = emit_text (out, "tmplab = tmplab_js; tmplab_js = 0;\n")
    val () = emit_nspc (out, ind+2)
    val () = emit_text (out, "switch(tmplab)\n")
    val () = emit_nspc (out, ind+2)
    val () = emit_text (out, "{\n")
//
    val () = emit2_branchseqlst (out, ind+4, inss)
//
    val () = emit_nspc (out, ind+2)
    val () = emit_text (out, "} // end-of-switch\n")
    val () = emit_nspc (out, ind+2)
    val () = emit_text (out, "if (tmplab_js === 0) break;\n")
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "} // endwhile\n")
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "// ATScaseofseq_end")
//
    val () = the_branchlablst_unset ((*void*))
//
  } (* end of [ATScaseofseq] *)
//
| ATSreturn (tmp) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "return ")
    val () = emit_i0de (out, tmp)
  }
| ATSreturn_void (tmp) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "return//_void")
  }
//
| ATSINSlab (lab) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "case ")
    val () =
    (
      emit_tmplab_index (out, lab); emit_COLON (out)
    ) (* end of [val] *)
    val () =
    (
      emit_text (out, " // "); emit_label (out, lab)
    ) (* end of [val] *)
  } (* end of [ATSINSlab] *)
//
| ATSINSgoto (lab) =>
  {
    val () = emit_nspc (out, ind)
    val () =
    (
      emit_text (out, "{ tmplab_js = ")
    ) (* end of [val] *)
    val () = emit_tmplab_index (out, lab)
    val () =
    (
      emit_text (out, "; break; } // "); emit_label (out, lab)
    ) (* end of [val] *)
  } (* end of [ATSINSgoto] *)
//
| ATSINSflab (flab) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "// ")
    val () = emit_label (out, flab)
  } (* end of [ATSINSflab] *)
//
| ATSINSfgoto (flab) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "funlab_js = ")
    val () = emit_funlab_index (out, flab)
    val () =
    (
      emit_text (out, " // "); emit_label (out, flab)
    ) (* end of [val] *)
  } (* end of [ATSINSfgoto] *)
//
| ATSINSmove (tmp, d0e) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_i0de (out, tmp)
    val () = emit_text (out, " = ")
    val () = emit_d0exp (out, d0e)
  } (* end of [ATSINSmove] *)
//
| ATSINSmove_void (tmp, d0e) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "// ATSINSmove_void\n")
    val () = emit_nspc (out, ind)
    val () = emit_d0exp (out, d0e)
  }
//
| ATSINSmove_nil (tmp) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_i0de (out, tmp)
    val () = emit_text (out, " = ")
    val () = emit_text (out, "null")
  }
| ATSINSmove_con0 (tmp, tag) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_i0de (out, tmp)
    val () = emit_text (out, " = ")
    val () = emit_PMVint (out, tag)
  }
//
| ATSINSmove_con1 _ =>
    emit2_ATSINSmove_con1 (out, ind, ins0)
| ATSINSmove_boxrec _ =>
    emit2_ATSINSmove_boxrec (out, ind, ins0)
//
| ATStailcalseq (inss) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "// ATStailcalseq_beg")
    val () = emit_ENDL (out)
    val () = emit2_instrlst (out, ind, inss)
    val () = emit_nspc (out, ind)
    val () = emit_text (out, "// ATStailcalseq_end")
  
  } (* end of [ATStailcalseq] *)
//
| ATSINSmove_tlcal (tmp, d0e) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_i0de (out, tmp)
    val () = emit_text (out, " = ")
    val () = emit_d0exp (out, d0e)  
  } (* end of [ATSINSmove_tlcal] *)
//
| ATSINSargmove_tlcal (tmp1, tmp2) =>
  {
    val () = emit_nspc (out, ind)
    val () = emit_i0de (out, tmp1)
    val () = emit_text (out, " = ")
    val () = emit_i0de (out, tmp2)
  } (* end of [ATSINSargmove_tlcal] *)
//
| _ (*rest*) =>
  {
    val () = emit_nspc (out, ind)
    val () = fprint_instr (out, ins0)
  }
//
end // end of [emit2_instr]

(* ****** ****** *)

implement
emit2_instr_ln
  (out, ind, ins) =
(
  emit2_instr (out, ind, ins); emit_newline (out)
) (* end of [emit2_instr_ln] *)

(* ****** ****** *)

implement
emit2_instrlst
(
  out, ind, inss
) = (
//
case+ inss of
| list_nil () => ()
| list_cons (ins, inss) =>
  {
    val () = emit2_instr (out, ind, ins)
    val () = emit_ENDL (out)
    val () = emit2_instrlst (out, ind, inss)
  }
//
) (* end of [emit2_instrlst] *)

(* ****** ****** *)

implement
emit2_branchseqlst
  (out, ind, inss) = let
//
fun auxseq
(
  out: FILEref
, ind: int, ins0: instr
) : void = let
in
//
case-
ins0.instr_node of
//
| ATSbranchseq
    (inss) => emit2_instrlst (out, ind, inss)
  // end of [ATSbranchseq]
//
end (* end of [auxseq] *)
//
fun auxseqlst
(
  out: FILEref
, ind: int, inss: instrlst
) : void = let
in
//
case+ inss of
| list_nil () => ()
| list_cons
    (ins, inss) => let
//
    val () = (
      emit_nspc (out, ind);
      emit_text (out, "// ATSbranchseq_beg\n")
    ) (* end of [val] *)
//
    val () = auxseq (out, ind, ins)
//
    val () = (
      emit_nspc (out, ind); emit_text (out, "break;\n")
    ) (* end of [val] *)
//
    val () = (
      emit_nspc (out, ind);
      emit_text (out, "// ATSbranchseq_end\n")
    ) (* end of [val] *)
//
  in
    auxseqlst (out, ind, inss)
  end (* end of [list_cons] *)
//
end (* end of [auxseqlst] *)
//
in
  auxseqlst (out, ind, inss)
end // end of [emit2_branchseqlst]

(* ****** ****** *)

implement
emit2_ATSfunbodyseq
  (out, ind, ins) = let
//
val-ATSfunbodyseq (inss) = ins.instr_node
//
in
  emit2_instrlst (out, ind, inss)
end // end of [emit2_ATS2funbodyseq]

(* ****** ****** *)

implement
emit2_ATSINSmove_con1
  (out, ind, ins0) = let
//
fun
getarglst
(
  inss: instrlst
) : d0explst =
(
case+ inss of
| list_nil () => list_nil ()
| list_cons (ins, inss) => let
    val-ATSINSstore_con1_ofs (_, _, _, d0e) = ins.instr_node
    val d0es = getarglst (inss)
  in
    list_cons (d0e, d0es)
  end // end of [list_cons]
)
//
val-ATSINSmove_con1 (inss) = ins0.instr_node
//
val-list_cons (ins, inss) = inss
val-ATSINSmove_con1_new (tmp, _) = ins.instr_node  
//
var opt: tokenopt = None()
//
val inss =
(
case+ inss of
| list_nil () => inss
| list_cons (ins, inss2) =>
  (
    case+ ins.instr_node of
    | ATSINSstore_con1_tag
        (tmp, tag) => let
        val () = opt := Some(tag) in inss2
      end // end of [ATSINSstore_con1_tag]
    | _ (*non-ATSINSstore_con1_tag*) => inss
  )
) : instrlst
//
val d0es = getarglst (inss)
val () = emit_nspc (out, ind)
val () = emit_i0de (out, tmp)
val () = emit_text (out, " = ")
val () = emit_LBRACKET (out)
val () =
(
case+ opt of
| None () => ()
| Some (tag) => emit_PMVint (out, tag)
) : void // end of [val]
val () =
(
case+ opt of
| None _ => emit_d0explst (out, d0es)
| Some _ => emit_d0explst_1 (out, d0es)
) : void // end of [val]
//
val () = emit_RBRACKET (out)
//
in
  // nothing
end // end of [emit2_ATSINSmove_con1]

(* ****** ****** *)

implement
emit2_ATSINSmove_boxrec
  (out, ind, ins0) = let
//
fun
getarglst
(
  inss: instrlst
) : d0explst =
(
case+ inss of
| list_nil () => list_nil ()
| list_cons (ins, inss) => let
    val-ATSINSstore_boxrec_ofs (_, _, _, d0e) = ins.instr_node
    val d0es = getarglst (inss)
  in
    list_cons (d0e, d0es)
  end // end of [list_cons]
)
//
val-ATSINSmove_boxrec (inss) = ins0.instr_node
//
val-list_cons (ins, inss) = inss
val-ATSINSmove_boxrec_new (tmp, _) = ins.instr_node  
//
val d0es = getarglst (inss)
//
val () = emit_nspc (out, ind)
val () = emit_i0de (out, tmp)
val () = emit_text (out, " = ")
val () = emit_LBRACKET (out)
val () = emit_d0explst (out, d0es)
val () = emit_RBRACKET (out)
//
in
  // nothing
end // end of [emit2_ATSINSmove_boxrec]

(* ****** ****** *)
//
extern
fun emit_f0arg : emit_type (f0arg)
extern
fun emit_f0marg : emit_type (f0marg)
extern
fun emit_f0head : emit_type (f0head)
//
extern
fun emit_f0body : emit_type (f0body)
extern
fun emit_f0body_0 : emit_type (f0body)
extern
fun emit_f0body_tlcal : emit_type (f0body)
extern
fun emit_f0body_tlcal2 : emit_type (f0body)
//
(* ****** ****** *)

implement
emit_f0arg
  (out, f0a) = let
in
//
case+
f0a.f0arg_node of
//
| F0ARGnone _ => emit_text (out, "__NONE__")
| F0ARGsome (id, s0e) => emit_i0de (out, id)
//
end // end of [emit_f0arg]

(* ****** ****** *)

implement
emit_f0marg
  (out, f0ma) = let
//
fun
loop
(
  out: FILEref, f0as: f0arglst, i: int
) : void =
(
case+ f0as of
| list_nil () => ()
| list_cons (f0a, f0as) => let
    val () =
      if i > 0 then emit_text (out, ", ")
    // end of [val]
  in
    emit_f0arg (out, f0a); loop (out, f0as, i+1)
  end // end of [list_cons]
)
//
in
  loop (out, f0ma.f0marg_node, 0)
end // end of [emit_f0marg]

(* ****** ****** *)

implement
emit_f0head
  (out, fhd) = let
//
val f0as =
  f0head_get_f0arglst (fhd)
//
val () = the_f0arglst_set (f0as)
//
in
//
case+
fhd.f0head_node of
| F0HEAD
    (id, f0ma, res) =>
  {
    val () = emit_i0de (out, id)
    val () = emit_LPAREN (out)
    val () = emit_f0marg (out, f0ma)
    val () = emit_RPAREN (out)
  }
//
end // end of [emit_f0head]

(* ****** ****** *)

implement
emit_f0body
  (out, fbody) = let
//
val knd = f0body_classify (fbody)
(*
val () =
println! ("emit_f0body: knd = ", knd)
*)
//
val tmpdecs =
  f0body_get_tmpdeclst (fbody)
val inss_body =
  f0body_get_bdinstrlst (fbody)
//
val () = the_tmpdeclst_set (tmpdecs)
val () = the_funbodylst_set (inss_body)
//
val () = emit_text (out, "{\n")
//
val () = emit_text (out, "//\n")
//
val () =
  emit_tmpdeclst_initize (out, tmpdecs)
//
val () =
if knd > 0 then
{
val () = emit_nspc (out, 2)
val () = emit_text (out, "var funlab_js\n")
val () = emit_nspc (out, 2)
val () = emit_text (out, "var tmplab, tmplab_js\n")
} (* end of [if] *) // end of [val]
//
val () = emit_text (out, "//\n")
//
val () = (
//
case+ knd of
| 1 => emit_f0body_tlcal (out, fbody)
| 2 => emit_f0body_tlcal2 (out, fbody)
| _ (*0*) => emit_f0body_0 (out, fbody)
//
) : void // end of [val]
//
val () = emit_text (out, "} // end-of-function\n")
//
in
  // nothing
end (* end of [emit_f0body] *)

(* ****** ****** *)

implement
emit_f0body_0
  (out, fbody) = let
//
fun
auxlst
(
  out: FILEref, inss: instrlst, i: int
) : void =
(
case+ inss of
| list_nil () => ()
| list_cons
    (ins0, inss1) => let
    val-list_cons (ins1, inss2) = inss1
    val () = if i > 0 then emit_ENDL (out)
    val () = emit2_ATSfunbodyseq (out, 2(*ind*), ins0)
    val () = emit2_instr_ln (out, 2(*ind*), ins1)
  in
    auxlst (out, inss2, i+1)
  end // end of [list_cons]
//
) (* end of [auxlst] *)
//
in
//
case+
fbody.f0body_node of
//
| F0BODY (tds, inss) =>
  {
    val () = auxlst (out, inss, 0(*i*))
  }
//
end // end of [emit_f0body_0]

(* ****** ****** *)

implement
emit_f0body_tlcal
  (out, fbody) = let
//
fun
auxlst
(
  out: FILEref, inss: instrlst
) : void =
(
case+ inss of
| list_nil () => ()
| list_cons
    (ins0, inss1) => let
    val-list_cons (ins1, inss2) = inss1
//
    val () =
      emit2_ATSfunbodyseq (out, 4(*ind*), ins0)
    // end of [val]
//
    val () = emit_nspc (out, 4(*ind*))
    val () =
    emit_text
    (
      out, "if (funlab_js > 0) continue; else"
    ) (* end of [val] *)
    val () = emit2_instr (out, 1(*ind*), ins1)
    val () = emit_text (out, ";\n")
//
    val () = emit_nspc (out, 2(*ind*))
    val () = emit_text (out, "} // endwhile\n")
  in
    auxlst (out, inss2(*nil*))
  end // end of [list_cons]
//
) (* end of [auxlst] *)
//
val () = emit_nspc (out, 2(*ind*))
val () = emit_text (out, "while(true) {\n")
val () = emit_nspc (out, 4(*ind*))
val () = emit_text (out, "funlab_js = 0\n")
//
val () =
(
case+
fbody.f0body_node of
//
| F0BODY (tds, inss) => auxlst (out, inss)
//
) (* end of [val] *)
//
in
  // nothing
end // end of [emit_f0body_tlcal]

(* ****** ****** *)
//
extern
fun
emit_the_funbodylst (out: FILEref): void
//
implement
emit_the_funbodylst
  (out) = let
//
fun auxfun
(
  out: FILEref
, ins0: instr, ins1: instr, i: int
) : void = let
//
val-ATSfunbodyseq(inss) = ins0.instr_node
//
val-list_cons (ins_fl, inss) = inss
val-ATSINSflab (fl) = ins_fl.instr_node
//
val () = emit_nspc (out, 6)
val () =
(
  emit_text (out, "case ");
  emit_int (out, i); emit_text (out, ": {\n")
)
val () = emit_nspc (out, 8)
val () = emit_text (out, "funlab_js = 0\n")
val () = emit2_instrlst (out, 8(*ind*), inss)
//
val () = emit_nspc (out, 8)
val () =
emit_text
(
  out, "if (funlab_js > 0) continue; else"
) (* end of [val] *)
val () = emit2_instr (out, 1(*ind*), ins1)
val () = emit_text (out, ";\n")
//
val () = emit_nspc (out, 6)
val () = emit_text (out, "} // end-of-case\n")
//
in
  // nothing
end // end of [auxfun]
//
fun auxlst
(
  out: FILEref, inss: instrlst, i: int
) : void =
(
case+ inss of
| list_nil () => ()
| list_cons _ => let
    val-list_cons (ins0, inss) = inss
    val-list_cons (ins1, inss) = inss
    val () = auxfun (out, ins0, ins1, i)
  in
    auxlst (out, inss, i+1)
  end // end of [auxlst]
) (* end of [auxlst] *)
//
in
  auxlst (out, the_funbodylst_get((*void*)), 1(*i*))
end // end of [emit_the_funbodylst]
//
(* ****** ****** *)

implement
emit_f0body_tlcal2
  (out, fbody) = let
//
val () = emit_nspc (out, 2(*ind*))
val () = emit_text (out, "funlab_js = 1\n")
//
val () = emit_nspc (out, 2(*ind*))
val () = emit_text (out, "while(true) {\n")
//
val () = emit_nspc (out, 4(*ind*))
val () = emit_text (out, "switch(funlab_js)\n")
val () = emit_nspc (out, 4(*ind*))
val ((*opening*)) = emit_text (out, "{\n")
//
val () = emit_the_funbodylst (out)
//
val () = emit_nspc (out, 4(*ind*))
val ((*closing*)) = emit_text (out, "} // end-of-switch\n")
val () = emit_nspc (out, 2(*ind*))
val ((*closing*)) = emit_text (out, "} // endwhile\n")
//
in
  // nothing
end // end of [emit_f0body_tlcal2]

(* ****** ****** *)

implement
emit_f0decl
  (out, fdec) = let
in
//
case+
fdec.f0decl_node of
| F0DECLnone (fhd) => () 
| F0DECLsome (fhd, fbody) =>
  {
    val () =
    emit_text
      (out, "function\n")
    // end of [val]
    val () = emit_f0head (out, fhd)
    val () = emit_newline (out)
    val () = emit_f0body (out, fbody)
    val () = emit_newline (out)
  } (* end of [F0DECLsome] *)
//
end // end of [emit_f0decl]

(* ****** ****** *)

implement
emit_toplevel
  (out, d0cs) = let
//
fun
loop
(
  out: FILEref, d0cs: d0eclist
) : void =
(
//
case+ d0cs of
| list_nil () => ()
| list_cons
    (d0c, d0cs) => let
  in
    emit_d0ecl (out, d0c); loop (out, d0cs)
  end // end of [list_cons]
//
)
//
in
  loop (out, d0cs)
end // end of [emit_toplevel]

(* ****** ****** *)

(* end of [atsparemit_emit2_js.dats] *)