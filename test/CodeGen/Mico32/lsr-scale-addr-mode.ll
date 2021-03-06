; RUN: llvm-as < %s | llc -march=mico32
; END.
; RUN: llvm-as < %s | llc -march=arm | grep -F {str r2, \[r0, +r3, lsl #2\]}
; Should use scaled addressing mode.

define void @sintzero(i32* %a) {
entry:
	store i32 0, i32* %a
	br label %cond_next

cond_next:		; preds = %cond_next, %entry
	%indvar = phi i32 [ 0, %entry ], [ %tmp25, %cond_next ]		; <i32> [#uses=1]
	%tmp25 = add i32 %indvar, 1		; <i32> [#uses=3]
	%tmp36 = getelementptr i32* %a, i32 %tmp25		; <i32*> [#uses=1]
	store i32 0, i32* %tmp36
	icmp eq i32 %tmp25, -1		; <i1>:0 [#uses=1]
	br i1 %0, label %return, label %cond_next

return:		; preds = %cond_next
	ret void
}
