; RUN: llvm-as < %s | llc -march=mico32
; END.
; RUN: llvm-as < %s | llc -march=ppc32 | grep fmul | count 2
; RUN: llvm-as < %s | llc -march=ppc32 -enable-unsafe-fp-math | \
; RUN:   grep fmul | count 1

define double @foo(double %X) {
        %tmp1 = fmul double %X, 1.23
        %tmp2 = fmul double %tmp1, 4.124
        ret double %tmp2
}

