; mico32 can only return <2 x i32> at most.
; XFAIL: *
; RUN: llvm-as < %s | llc -march=mico32
; END.
; RUN: llvm-as < %s | llc -march=ppc32 -mcpu=g5 | grep vsldoi
; RUN: llvm-as < %s | llc -march=ppc32 -mcpu=g5 | not grep vor

define <4 x float> @func(<4 x float> %fp0, <4 x float> %fp1) {
        %tmp76 = shufflevector <4 x float> %fp0, <4 x float> %fp1, <4 x i32> < i32 0, i32 1, i32 2, i32 7 >     ; <<4 x float>> [#uses=1]
        ret <4 x float> %tmp76
}
