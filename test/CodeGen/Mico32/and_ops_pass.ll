; RUN: llvm-as -o - %s | llc -march=mico32
; END.
; RUN: llvm-as -o - %s | llc -march=cellspu > %t1.s
; RUN: grep and    %t1.s | count 234
; RUN: grep andc   %t1.s | count 85
; RUN: grep andi   %t1.s | count 37
; RUN: grep andhi  %t1.s | count 30
; RUN: grep andbi  %t1.s | count 4

; AND instruction generation:
define <2 x i32> @and_v2i32_1(<2 x i32> %arg1, <2 x i32> %arg2) {
        %A = and <2 x i32> %arg1, %arg2
        ret <2 x i32> %A
}

define <2 x i32> @and_v2i32_2(<2 x i32> %arg1, <2 x i32> %arg2) {
        %A = and <2 x i32> %arg2, %arg1
        ret <2 x i32> %A
}

define <2 x i16> @and_v2i16_1(<2 x i16> %arg1, <2 x i16> %arg2) {
        %A = and <2 x i16> %arg1, %arg2
        ret <2 x i16> %A
}

define <2 x i16> @and_v2i16_2(<2 x i16> %arg1, <2 x i16> %arg2) {
        %A = and <2 x i16> %arg2, %arg1
        ret <2 x i16> %A
}

define <2 x i8> @and_v2i8_1(<2 x i8> %arg1, <2 x i8> %arg2) {
        %A = and <2 x i8> %arg2, %arg1
        ret <2 x i8> %A
}

define <2 x i8> @and_v2i8_2(<2 x i8> %arg1, <2 x i8> %arg2) {
        %A = and <2 x i8> %arg1, %arg2
        ret <2 x i8> %A
}

define i32 @and_i32_1(i32 %arg1, i32 %arg2) {
        %A = and i32 %arg2, %arg1
        ret i32 %A
}

define i32 @and_i32_2(i32 %arg1, i32 %arg2) {
        %A = and i32 %arg1, %arg2
        ret i32 %A
}

define i16 @and_i16_1(i16 %arg1, i16 %arg2) {
        %A = and i16 %arg2, %arg1
        ret i16 %A
}

define i16 @and_i16_2(i16 %arg1, i16 %arg2) {
        %A = and i16 %arg1, %arg2
        ret i16 %A
}

define i8 @and_i8_1(i8 %arg1, i8 %arg2) {
        %A = and i8 %arg2, %arg1
        ret i8 %A
}

define i8 @and_i8_2(i8 %arg1, i8 %arg2) {
        %A = and i8 %arg1, %arg2
        ret i8 %A
}

; ANDC instruction generation:
define <2 x i32> @andc_v2i32_1(<2 x i32> %arg1, <2 x i32> %arg2) {
        %A = xor <2 x i32> %arg2, < i32 -1, i32 -1 >
        %B = and <2 x i32> %arg1, %A
        ret <2 x i32> %B
}

define <2 x i32> @andc_v2i32_2(<2 x i32> %arg1, <2 x i32> %arg2) {
        %A = xor <2 x i32> %arg1, < i32 -1, i32 -1 >
        %B = and <2 x i32> %arg2, %A
        ret <2 x i32> %B
}

define <2 x i32> @andc_v2i32_3(<2 x i32> %arg1, <2 x i32> %arg2) {
        %A = xor <2 x i32> %arg1, < i32 -1, i32 -1 >
        %B = and <2 x i32> %A, %arg2
        ret <2 x i32> %B
}

define <2 x i16> @andc_v2i16_1(<2 x i16> %arg1, <2 x i16> %arg2) {
        %A = xor <2 x i16> %arg2, <i16 -1, i16 -1>
        %B = and <2 x i16> %arg1, %A
        ret <2 x i16> %B
}

define <2 x i16> @andc_v2i16_2(<2 x i16> %arg1, <2 x i16> %arg2) {
        %A = xor <2 x i16> %arg1, < i16 -1, i16 -1>
        %B = and <2 x i16> %arg2, %A
        ret <2 x i16> %B
}

define <2 x i8> @andc_v2i8_1(<2 x i8> %arg1, <2 x i8> %arg2) {
        %A = xor <2 x i8> %arg1, < i8 -1, i8 -1 >
        %B = and <2 x i8> %arg2, %A
        ret <2 x i8> %B
}

define <2 x i8> @andc_v2i8_2(<2 x i8> %arg1, <2 x i8> %arg2) {
        %A = xor <2 x i8> %arg2, < i8 -1, i8 -1 >
        %B = and <2 x i8> %arg1, %A
        ret <2 x i8> %B
}

define <2 x i8> @andc_v2i8_3(<2 x i8> %arg1, <2 x i8> %arg2) {
        %A = xor <2 x i8> %arg2, < i8 -1, i8 -1>
        %B = and <2 x i8> %A, %arg1
        ret <2 x i8> %B
}

define i32 @andc_i32_1(i32 %arg1, i32 %arg2) {
        %A = xor i32 %arg2, -1
        %B = and i32 %A, %arg1
        ret i32 %B
}

define i32 @andc_i32_2(i32 %arg1, i32 %arg2) {
        %A = xor i32 %arg1, -1
        %B = and i32 %A, %arg2
        ret i32 %B
}

define i32 @andc_i32_3(i32 %arg1, i32 %arg2) {
        %A = xor i32 %arg2, -1
        %B = and i32 %arg1, %A
        ret i32 %B
}

define i16 @andc_i16_1(i16 %arg1, i16 %arg2) {
        %A = xor i16 %arg2, -1
        %B = and i16 %A, %arg1
        ret i16 %B
}

define i16 @andc_i16_2(i16 %arg1, i16 %arg2) {
        %A = xor i16 %arg1, -1
        %B = and i16 %A, %arg2
        ret i16 %B
}

define i16 @andc_i16_3(i16 %arg1, i16 %arg2) {
        %A = xor i16 %arg2, -1
        %B = and i16 %arg1, %A
        ret i16 %B
}

define i8 @andc_i8_1(i8 %arg1, i8 %arg2) {
        %A = xor i8 %arg2, -1
        %B = and i8 %A, %arg1
        ret i8 %B
}

define i8 @andc_i8_2(i8 %arg1, i8 %arg2) {
        %A = xor i8 %arg1, -1
        %B = and i8 %A, %arg2
        ret i8 %B
}

define i8 @andc_i8_3(i8 %arg1, i8 %arg2) {
        %A = xor i8 %arg2, -1
        %B = and i8 %arg1, %A
        ret i8 %B
}

; ANDI instruction generation (i32 data type):
define <2 x i32> @andi_v2i32_1(<2 x i32> %in) {
        %tmp2 = and <2 x i32> %in, < i32 511, i32 511 >
        ret <2 x i32> %tmp2
}

define <2 x i32> @andi_v2i32_2(<2 x i32> %in) {
        %tmp2 = and <2 x i32> %in, < i32 510, i32 510 >
        ret <2 x i32> %tmp2
}

define <2 x i32> @andi_v2i32_3(<2 x i32> %in) {
        %tmp2 = and <2 x i32> %in, < i32 -1, i32 -1 >
        ret <2 x i32> %tmp2
}

define <2 x i32> @andi_v2i32_2b(<2 x i32> %in) {
        %tmp2 = and <2 x i32> %in, < i32 -512, i32 -512 >
        ret <2 x i32> %tmp2
}

define zeroext i32 @andi_u32(i32 zeroext  %in) {
        %tmp37 = and i32 %in, 37
        ret i32 %tmp37
}

define signext i32 @andi_i32(i32 signext  %in) {
        %tmp38 = and i32 %in, 37
        ret i32 %tmp38
}

define i32 @andi_i32_1(i32 %in) {
        %tmp37 = and i32 %in, 37
        ret i32 %tmp37
}

; ANDHI instruction generation (i16 data type):
define <2 x i16> @andhi_v2i16_1(<2 x i16> %in) {
        %tmp2 = and <2 x i16> %in, < i16 511, i16 511>
        ret <2 x i16> %tmp2
}

define <2 x i16> @andhi_v2i16_2(<2 x i16> %in) {
        %tmp2 = and <2 x i16> %in, < i16 510, i16 510>
        ret <2 x i16> %tmp2
}

define <2 x i16> @andhi_v2i16_3(<2 x i16> %in) {
        %tmp2 = and <2 x i16> %in, < i16 -1, i16 -1>
        ret <2 x i16> %tmp2
}

define <2 x i16> @andhi_v2i16_2b(<2 x i16> %in) {
        %tmp2 = and <2 x i16> %in, < i16 -512, i16 -512>
        ret <2 x i16> %tmp2
}

define zeroext i16 @andhi_u16(i16 zeroext  %in) {
        %tmp37 = and i16 %in, 37         ; <i16> [#uses=1]
        ret i16 %tmp37
}

define signext i16 @andhi_i16(i16 signext  %in) {
        %tmp38 = and i16 %in, 37         ; <i16> [#uses=1]
        ret i16 %tmp38
}

; i8 data type (s/b ANDBI if 8-bit registers were supported):
define <2 x i8> @and_v2i8(<2 x i8> %in) {
        ; ANDBI generated for vector types
        %tmp2 = and <2 x i8> %in, < i8 42, i8 42>
        ret <2 x i8> %tmp2
}

define zeroext i8 @and_u8(i8 zeroext  %in) {
        ; ANDBI generated:
        %tmp37 = and i8 %in, 37
        ret i8 %tmp37
}

define signext i8 @and_sext8(i8 signext  %in) {
        ; ANDBI generated
        %tmp38 = and i8 %in, 37
        ret i8 %tmp38
}

define i8 @and_i8(i8 %in) {
        ; ANDBI generated
        %tmp38 = and i8 %in, 205
        ret i8 %tmp38
}
