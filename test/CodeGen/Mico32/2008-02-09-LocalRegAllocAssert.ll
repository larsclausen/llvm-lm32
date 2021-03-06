; RUN: llvm-as < %s | llc -march=mico32
; END.
; RUN: llvm-as < %s | llc -mtriple=powerpc-apple-darwin -regalloc=local

define i32 @bork(i64 %foo, i64 %bar) {
entry:
        %tmp = load i64* null, align 8          ; <i64> [#uses=2]
        %tmp2 = icmp ule i64 %tmp, 0            ; <i1> [#uses=1]
        %min = select i1 %tmp2, i64 %tmp, i64 0   ; <i64> [#uses=1]
        store i64 %min, i64* null, align 8
        ret i32 0
}
