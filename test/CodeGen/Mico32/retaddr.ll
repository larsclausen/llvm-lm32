; RUN: llvm-as < %s | llc -march=mico32
; END.
; RUN: llvm-as < %s | llc -march=ppc32 | grep mflr
; RUN: llvm-as < %s | llc -march=ppc32 | grep lwz
; RUN: llvm-as < %s | llc -march=ppc64 | grep {ld r., 16(r1)}

define void @foo(i8** %X) {
entry:
	%tmp = tail call i8* @llvm.returnaddress( i32 0 )		; <i8*> [#uses=1]
	store i8* %tmp, i8** %X, align 4
	ret void
}

declare i8* @llvm.returnaddress(i32)

