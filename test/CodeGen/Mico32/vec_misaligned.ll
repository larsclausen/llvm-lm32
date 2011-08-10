; RUN: llvm-as < %s | llc -march=mico32
; END.
; RUN: llvm-as < %s | llc -march=ppc32 -mcpu=g5

	%struct.S2203 = type { %struct.u16qi }
	%struct.u16qi = type { <16 x i8> }
@s = weak global %struct.S2203 zeroinitializer		; <%struct.S2203*> [#uses=1]

define void @foo(i32 %x, ...) {
entry:
	%x_addr = alloca i32		; <i32*> [#uses=1]
	%ap = alloca i8*		; <i8**> [#uses=3]
	%ap.0 = alloca i8*		; <i8**> [#uses=3]
	%"alloca point" = bitcast i32 0 to i32		; <i32> [#uses=0]
	store i32 %x, i32* %x_addr
	%ap1 = bitcast i8** %ap to i8*		; <i8*> [#uses=1]
	call void @llvm.va_start( i8* %ap1 )
	%tmp = load i8** %ap, align 4		; <i8*> [#uses=1]
	store i8* %tmp, i8** %ap.0, align 4
	%tmp2 = load i8** %ap.0, align 4		; <i8*> [#uses=1]
	%tmp3 = getelementptr i8* %tmp2, i64 16		; <i8*> [#uses=1]
	store i8* %tmp3, i8** %ap, align 4
	%tmp4 = load i8** %ap.0, align 4		; <i8*> [#uses=1]
	%tmp45 = bitcast i8* %tmp4 to %struct.S2203*		; <%struct.S2203*> [#uses=1]
	%tmp6 = getelementptr %struct.S2203* @s, i32 0, i32 0		; <%struct.u16qi*> [#uses=1]
	%tmp7 = getelementptr %struct.S2203* %tmp45, i32 0, i32 0		; <%struct.u16qi*> [#uses=1]
	%tmp8 = getelementptr %struct.u16qi* %tmp6, i32 0, i32 0		; <<16 x i8>*> [#uses=1]
	%tmp9 = getelementptr %struct.u16qi* %tmp7, i32 0, i32 0		; <<16 x i8>*> [#uses=1]
	%tmp10 = load <16 x i8>* %tmp9, align 4		; <<16 x i8>> [#uses=1]
	store <16 x i8> %tmp10, <16 x i8>* %tmp8, align 4
	br label %return

return:		; preds = %entry
	ret void
}

declare void @llvm.va_start(i8*) nounwind 