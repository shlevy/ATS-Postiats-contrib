// staload _ = "prelude/DATS/integer.dats"

(* ****** ****** *)

staload "contrib/libats-/wdblair/prelude/SATS/array.sats"
staload "contrib/libats-/wdblair/patsolve/SATS/stampseq.sats"

(* ****** ****** *)

// assume T(a:t@ype, xs:stamp) = a

(* ****** ****** *)

typedef cmp_fn(a:t@ype) = {l1,l2:addr} {x1,x2:stamp} (
  !T(a, x1) @ l1, !T(a, x2) @ l2 | 
    ptr (l1), ptr (l2)) -> int (sgn(x1-x2))
    
(* ****** ****** *)

extern
praxi array_sorted_len_lemma 
                 {a:t@ype} {l:addr} {xs:stmsq | ordered(xs)} {n:nat} (
    pf: array_v (a, l, xs, n)
): [sorted(xs, n)] void

extern
praxi array_ordered_lemma
                 {a:t@ype} {l:addr} {xs:stmsq | sorted(xs, n)} {n:nat} (
    pf: array_v (a, l, xs, n)
): [ordered(xs)] void

(* ****** ****** *)

extern
fun
sort {a:t@ype} {l:addr} {xs:stmsq} {n:nat | n != 0} (
  pf: array_v (a, l, xs, n) | 
    p: ptr l, n: size_t n, sz: size_t (sizeof(a)), cmp: cmp_fn(a)
): [ys:stmsq | ordered(ys)] (
  array_v (a, l, ys, n) | void
)

implement
sort {a}{l}{xs}{n}
  (pf | p, n, sz, cmp) = let
  
  fun 
  loop {m:nat | m <= n}
           {ys:stmsq | ordered(ys)} (
    pfsorted: array_v (a, l, ys, m), 
    pfrem: array_v (a, l+m*sizeof(a), drop(xs, m), n-m) |
      ps: ptr l, pr: ptr (l+m*sizeof(a)), m: size_t (m)
  ): [zs:stmsq | ordered(zs)] (
    array_v (a, l, zs, n) | void
  ) =
    if m = n then let
        prval array_v_nil () = pfrem
    in 
         (pfsorted | ())
    end
    else let
    
           fun
          insert {n:nat}  {l:addr}
                      {x:stamp} {xs:stmsq | ordered(xs)} (
              pfxs: array_v (a, l, xs, n), pfx: T(a, x) @ l + n*sizeof(a) |  
                  p: ptr l,  px: ptr (l + n *sizeof(a)), n: size_t n
          ): [ys:stmsq | ordered(ys)] (
                  array_v (a, l, ys, n+1) | void
          ) = let
              prval () = array_sorted_len_lemma (pfxs)
              
              fun
              loop {i:nat | i < n} {x:stamp} {xs:stmsq | sorted(xs, n)} (
                  pf: array (a, l, insert(xs, i, x), n+1) | pi: ptr (l+i*sizeof(a))
              ): [j:nat | sorted(insert(xs, j, x), n+1)] (
                  array_v (a, l, insert(xs, j, x), n+1)
              ) =
                  if ps = pi then let
                      prval () = equal_ptr_lemma {..}{l}{0,i} ()
                   
           in
          
          end
            
          prval array_v_cons (pfr, pfrss) = pfrem
          val (pfinserted | ()) = insert (pfsorted, pfr | ps, pr, m)
     in
         loop (pfinserted, pfrss | ps, add_ptr_bsz(pr, sz), succ(m))
     end
        
in
    loop (array_v_nil(), pf | p, p, u2sz(0u))
end


    

        


       
