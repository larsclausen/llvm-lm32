; RUN: llvm-as < %s | llc -march=mico32
; END.
; RUN: llvm-as < %s | llc

define i32 @test(i32 %X) {
        %Y = sdiv i32 %X, -2            ; <i32> [#uses=1]
        ret i32 %Y
}

