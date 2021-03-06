; RUN: llvm-as < %s | llc -march=mico32
; END.
; RUN: llvm-as < %s | llc -march=ppc32 | grep cntlzw 
; RUN: llvm-as < %s | llc -march=ppc32 | not grep xori 
; RUN: llvm-as < %s | llc -march=ppc32 | not grep {li }
; RUN: llvm-as < %s | llc -march=ppc32 | not grep {mr }

define i1 @test(i64 %x) {
  %tmp = icmp ult i64 %x, 4294967296
  ret i1 %tmp
}
