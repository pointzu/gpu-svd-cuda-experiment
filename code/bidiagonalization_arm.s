	.arch armv8-a
	.file	"bidiagonalization.cpp"
	.text
	.align	2
	.p2align 4,,11
	.type	_ZN12_GLOBAL__N_1L16simd_sum_squaresEPKdi, %function
_ZN12_GLOBAL__N_1L16simd_sum_squaresEPKdi:
.LFB7799:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	cmp	w1, 1
	ble	.L6
	sub	w2, w1, #2
	add	x4, x0, 16
	movi	v1.2d, 0
	mov	x3, x0
	lsr	w2, w2, 1
	add	x4, x4, x2, uxtw 4
	.p2align 3,,7
.L3:
	ldr	q0, [x3], 16
	fmla	v1.2d, v0.2d, v0.2d
	cmp	x3, x4
	bne	.L3
	add	w2, w2, 1
	lsl	w2, w2, 1
.L2:
	str	q1, [sp]
	ldp	d0, d1, [sp]
	fadd	d0, d0, d1
	cmp	w1, w2
	ble	.L1
	sxtw	x2, w2
	.p2align 3,,7
.L5:
	ldr	d1, [x0, x2, lsl 3]
	add	x2, x2, 1
	fmadd	d0, d1, d1, d0
	cmp	w1, w2
	bgt	.L5
.L1:
	add	sp, sp, 16
	.cfi_remember_state
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L6:
	.cfi_restore_state
	movi	v1.2d, 0
	mov	w2, 0
	b	.L2
	.cfi_endproc
.LFE7799:
	.size	_ZN12_GLOBAL__N_1L16simd_sum_squaresEPKdi, .-_ZN12_GLOBAL__N_1L16simd_sum_squaresEPKdi
	.align	2
	.p2align 4,,11
	.type	_ZN12_GLOBAL__N_1L8simd_dotEPKdS1_i, %function
_ZN12_GLOBAL__N_1L8simd_dotEPKdS1_i:
.LFB7800:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	cmp	w2, 1
	ble	.L16
	sub	w3, w2, #2
	add	x6, x0, 16
	movi	v0.2d, 0
	mov	x4, x0
	lsr	w3, w3, 1
	mov	x5, x1
	add	x6, x6, x3, uxtw 4
	.p2align 3,,7
.L13:
	ldr	q1, [x4], 16
	ldr	q2, [x5], 16
	fmla	v0.2d, v2.2d, v1.2d
	cmp	x4, x6
	bne	.L13
	add	w3, w3, 1
	lsl	w3, w3, 1
.L12:
	str	q0, [sp]
	ldp	d0, d1, [sp]
	fadd	d0, d0, d1
	cmp	w2, w3
	ble	.L11
	sxtw	x3, w3
	.p2align 3,,7
.L15:
	ldr	d2, [x0, x3, lsl 3]
	ldr	d1, [x1, x3, lsl 3]
	add	x3, x3, 1
	fmadd	d0, d2, d1, d0
	cmp	w2, w3
	bgt	.L15
.L11:
	add	sp, sp, 16
	.cfi_remember_state
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L16:
	.cfi_restore_state
	movi	v0.2d, 0
	mov	w3, 0
	b	.L12
	.cfi_endproc
.LFE7800:
	.size	_ZN12_GLOBAL__N_1L8simd_dotEPKdS1_i, .-_ZN12_GLOBAL__N_1L8simd_dotEPKdS1_i
	.align	2
	.p2align 4,,11
	.type	_ZN12_GLOBAL__N_1L15simd_add_scaledEPdPKddi, %function
_ZN12_GLOBAL__N_1L15simd_add_scaledEPdPKddi:
.LFB7801:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	uxtw	x6, w2
	str	w2, [sp, 12]
	cmp	w6, 1
	ble	.L27
	sub	w5, w6, #2
	add	x4, x0, 16
	dup	v3.2d, v0.d[0]
	mov	x2, x0
	lsr	w5, w5, 1
	mov	x3, x1
	add	x4, x4, x5, uxtw 4
	.p2align 3,,7
.L23:
	ldr	q2, [x3], 16
	ldr	q1, [x2]
	fmla	v1.2d, v3.2d, v2.2d
	str	q1, [x2], 16
	cmp	x2, x4
	bne	.L23
	add	w5, w5, 1
	lsl	w5, w5, 1
.L24:
	cmp	w5, w6
	bge	.L20
	sxtw	x5, w5
	ldr	d2, [x1, x5, lsl 3]
	ldr	d1, [x0, x5, lsl 3]
	fmadd	d0, d0, d2, d1
	str	d0, [x0, x5, lsl 3]
.L20:
	add	sp, sp, 16
	.cfi_remember_state
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L27:
	.cfi_restore_state
	mov	w5, 0
	b	.L24
	.cfi_endproc
.LFE7801:
	.size	_ZN12_GLOBAL__N_1L15simd_add_scaledEPdPKddi, .-_ZN12_GLOBAL__N_1L15simd_add_scaledEPdPKddi
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"to_bidiagonal: requires m >= n"
	.align	3
.LC1:
	.string	"cannot create std::vector larger than max_size()"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z13to_bidiagonalRK6MatrixRS_S2_
	.type	_Z13to_bidiagonalRK6MatrixRS_S2_, %function
_Z13to_bidiagonalRK6MatrixRS_S2_:
.LFB7803:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA7803
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	mov	x19, x0
	ldp	w20, w0, [x0]
	stp	x27, x28, [sp, 80]
	stp	d8, d9, [sp, 96]
	str	d10, [sp, 112]
	str	w0, [sp, 140]
	stp	x1, x2, [sp, 160]
	cmp	w0, w20
	.cfi_offset 27, -160
	.cfi_offset 28, -152
	.cfi_offset 72, -144
	.cfi_offset 73, -136
	.cfi_offset 74, -128
	bgt	.L198
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -168
	.cfi_offset 25, -176
	add	x25, x8, 8
	ldr	w0, [sp, 140]
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -184
	.cfi_offset 23, -192
	mov	x23, x8
	ldr	x21, [x19, 16]
	stp	w20, w0, [x8]
	ldr	x0, [x19, 8]
	str	xzr, [x8, 8]
	stp	xzr, xzr, [x25, 8]
	subs	x21, x21, x0
	beq	.L127
	mov	x0, 9223372036854775800
	cmp	x21, x0
	bhi	.L199
	mov	x0, x21
.LEHB0:
	bl	_Znwm
.LEHE0:
	mov	x3, x0
.L30:
	str	x3, [x23, 8]
	add	x21, x3, x21
	stp	x3, x21, [x25, 8]
	ldp	x1, x0, [x19, 8]
	sub	x19, x0, x1
	cmp	x1, x0
	beq	.L33
	mov	x0, x3
	mov	x2, x19
	bl	memmove
	mov	x3, x0
.L33:
	mul	w0, w20, w20
	add	x3, x3, x19
	str	x3, [x25, 8]
	cbz	w0, .L128
	sbfiz	x19, x0, 3, 32
	mov	x0, x19
.LEHB1:
	bl	_Znwm
	mov	x2, x19
	mov	x21, x0
	add	x19, x0, x19
	mov	w1, 0
	bl	memset
.L34:
	ldr	x1, [sp, 160]
	add	x2, x1, 8
	str	x2, [sp, 200]
	ldr	x0, [x1, 8]
	str	w20, [x1]
	str	w20, [x1, 4]
	str	x21, [x1, 8]
	stp	x19, x19, [x2, 8]
	cbz	x0, .L35
	bl	_ZdlPv
.L35:
	cmp	w20, 0
	ble	.L39
	ldr	x0, [sp, 160]
	mov	w1, 0
	fmov	d0, 1.0e+0
	ldrsw	x2, [x0, 4]
	ldr	x0, [x0, 8]
	add	x2, x2, 1
	lsl	x2, x2, 3
	.p2align 3,,7
.L40:
	add	w1, w1, 1
	str	d0, [x0]
	add	x0, x0, x2
	cmp	w1, w20
	bne	.L40
.L39:
	ldr	w0, [sp, 140]
	mov	x21, 0
	mov	x19, 0
	mul	w0, w0, w0
	cbz	w0, .L38
	sbfiz	x19, x0, 3, 32
	mov	x0, x19
	bl	_Znwm
	mov	x2, x19
	mov	x21, x0
	add	x19, x0, x19
	mov	w1, 0
	bl	memset
.L38:
	ldr	x1, [sp, 168]
	ldr	w3, [sp, 140]
	add	x2, x1, 8
	str	x2, [sp, 224]
	ldr	x0, [x1, 8]
	stp	w3, w3, [x1]
	str	x21, [x1, 8]
	stp	x19, x19, [x2, 8]
	cbz	x0, .L41
	bl	_ZdlPv
.L41:
	ldr	w3, [sp, 140]
	cmp	w3, 0
	ble	.L28
	ldr	x0, [sp, 168]
	mov	w1, 0
	fmov	d0, 1.0e+0
	ldrsw	x2, [x0, 4]
	ldr	x0, [x0, 8]
	add	x2, x2, 1
	lsl	x2, x2, 3
	.p2align 3,,7
.L44:
	add	w1, w1, 1
	str	d0, [x0]
	add	x0, x0, x2
	cmp	w1, w3
	bne	.L44
	sxtw	x0, w20
	mov	x1, x0
	str	x1, [sp, 184]
	mov	x0, 1152921504606846975
	cmp	x1, x0
	bhi	.L123
	ldr	x0, [sp, 184]
	str	x0, [sp, 128]
	str	wzr, [sp, 136]
	mov	w21, w20
	mov	x27, 0
	lsl	x1, x0, 3
	adrp	x0, .LC2
	str	x1, [sp, 208]
	ldr	d9, [x0, #:lo12:.LC2]
	sub	w0, w20, #1
	ldr	w1, [sp, 140]
	str	w0, [sp, 156]
	adrp	x0, .LC3
	ldr	d10, [x0, #:lo12:.LC3]
	sub	w0, w1, #2
	str	w0, [sp, 152]
	sbfiz	x2, x1, 3, 32
	ldr	x0, [sp, 128]
	str	x2, [sp, 216]
	lsl	x24, x0, 3
	cbz	x0, .L130
	.p2align 3,,7
.L201:
	mov	x0, x24
	bl	_Znwm
.LEHE1:
	add	x1, x0, x24
	str	x1, [sp, 144]
	mov	x19, x0
	cmp	x1, x0
	beq	.L131
	mov	x28, x24
	ubfx	x22, x24, 3, 32
	mov	x2, x24
	mov	w1, 0
	bl	memset
.L46:
	cmp	w21, 0
	ble	.L50
	ldr	w1, [x23, 4]
	mov	x0, 0
	ldr	w4, [sp, 136]
	ldr	x3, [x25]
	sbfiz	x2, x1, 3, 32
	mul	w1, w1, w4
	add	x1, x27, x1, sxtw
	add	x1, x3, x1, lsl 3
	.p2align 3,,7
.L51:
	ldr	d0, [x1]
	add	x1, x1, x2
	str	d0, [x19, x0, lsl 3]
	add	x0, x0, 1
	cmp	w21, w0
	bgt	.L51
.L50:
	mov	w1, w22
	mov	x0, x19
	bl	_ZN12_GLOBAL__N_1L16simd_sum_squaresEPKdi
	fcmp	d0, #0.0
	bpl	.L48
	bl	sqrt
	fmov	d8, d0
	b	.L52
	.p2align 2,,3
.L48:
	fsqrt	d8, d0
.L52:
	fcmpe	d8, d9
	bgt	.L146
.L53:
	ldr	w0, [sp, 136]
	add	w22, w0, 1
	cmp	w22, w20
	bge	.L78
	ldr	w0, [x23, 4]
	mov	w1, w22
	ldr	x3, [x25]
	sbfiz	x2, x0, 3, 32
	mul	w0, w22, w0
	add	x0, x27, x0, sxtw
	add	x0, x3, x0, lsl 3
	.p2align 3,,7
.L79:
	add	w1, w1, 1
	str	xzr, [x0]
	add	x0, x0, x2
	cmp	w1, w20
	bne	.L79
.L78:
	ldr	w1, [sp, 136]
	ldr	w0, [sp, 152]
	cmp	w0, w1
	bgt	.L200
.L77:
	cbz	x19, .L109
	mov	x0, x19
	bl	_ZdlPv
.L109:
	ldr	w0, [sp, 140]
	cmp	w22, w0
	beq	.L28
	ldr	x0, [sp, 128]
	add	x27, x27, 1
	sub	w21, w21, #1
	sub	x0, x0, #1
	mov	x1, x0
	str	x1, [sp, 128]
	mov	x0, 1152921504606846975
	cmp	x1, x0
	bhi	.L123
	ldr	x0, [sp, 128]
	str	w22, [sp, 136]
	lsl	x24, x0, 3
	cbnz	x0, .L201
.L130:
	mov	w22, 0
	mov	x28, 0
	mov	x19, 0
	str	xzr, [sp, 144]
	b	.L46
	.p2align 2,,3
.L200:
	ldr	w0, [sp, 140]
	sub	w28, w0, w22
	mov	x0, 1152921504606846975
	sxtw	x26, w28
	cmp	x26, x0
	bhi	.L202
	cbz	x26, .L134
	lsl	x26, x26, 3
	mov	x0, x26
.LEHB2:
	bl	_Znwm
.LEHE2:
	mov	w1, 0
	mov	x2, x26
	str	x0, [sp, 144]
	str	x26, [sp, 176]
	bl	memset
	ldr	x0, [sp, 176]
	ldr	x3, [sp, 144]
	ubfx	x0, x0, 3, 32
	str	x0, [sp, 192]
	add	x1, x3, x26
	str	x1, [sp, 232]
	cmp	w28, 0
	ble	.L81
	ldr	w1, [x23, 4]
	mov	x0, 0
	ldr	w4, [sp, 136]
	ldr	x2, [x25]
	mul	w1, w4, w1
	add	x1, x27, x1, sxtw
	add	x1, x1, 1
	add	x1, x2, x1, lsl 3
	mov	x2, x3
	.p2align 3,,7
.L82:
	ldr	d0, [x1, x0, lsl 3]
	str	d0, [x2, x0, lsl 3]
	add	x0, x0, 1
	cmp	w28, w0
	bgt	.L82
.L81:
	ldr	w1, [sp, 192]
	ldr	x0, [sp, 144]
	bl	_ZN12_GLOBAL__N_1L16simd_sum_squaresEPKdi
	fcmp	d0, #0.0
	bpl	.L148
.L204:
	bl	sqrt
	fmov	d8, d0
	b	.L85
	.p2align 2,,3
.L146:
	ldr	w1, [sp, 136]
	ldr	w0, [sp, 156]
	cmp	w0, w1
	ble	.L53
	ldr	d1, [x19]
	fneg	d0, d8
	fcmpe	d1, #0.0
	fcsel	d8, d8, d0, ge
	cbz	x28, .L132
	mov	x0, 9223372036854775800
	cmp	x28, x0
	bhi	.L203
	mov	x0, x28
.LEHB3:
	bl	_Znwm
.LEHE3:
	mov	x26, x0
.L56:
	ldr	x0, [sp, 144]
	cmp	x19, x0
	beq	.L58
	mov	x2, x28
	mov	x1, x19
	mov	x0, x26
	bl	memcpy
.L58:
	ldr	d0, [x26]
	mov	w1, w22
	mov	x0, x26
	fadd	d0, d0, d8
	str	d0, [x26]
	bl	_ZN12_GLOBAL__N_1L16simd_sum_squaresEPKdi
	fcmpe	d0, d10
	bgt	.L147
.L59:
	mov	x0, x26
	bl	_ZdlPv
	b	.L53
	.p2align 2,,3
.L28:
	mov	x0, x23
	ldr	d10, [sp, 112]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	.cfi_remember_state
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	ldp	d8, d9, [sp, 96]
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 74
	.cfi_restore 72
	.cfi_restore 73
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L132:
	.cfi_restore_state
	mov	x26, 0
	b	.L56
.L131:
	mov	w22, 0
	mov	x28, 0
	b	.L46
	.p2align 2,,3
.L148:
	fsqrt	d8, d0
.L85:
	fcmpe	d8, d9
	bgt	.L149
	ldp	w0, w1, [sp, 136]
	add	w0, w0, 2
	cmp	w1, w0
	ble	.L108
.L105:
	ldp	w4, w2, [sp, 136]
	ldr	w3, [x23, 4]
	ldr	w1, [sp, 152]
	cmp	w2, w0
	sxtw	x0, w0
	mov	x2, 8
	sub	w1, w1, w22
	mul	w3, w4, w3
	add	x1, x1, 1
	ldr	x4, [x25]
	lsl	x1, x1, 3
	add	x0, x0, x3, sxtw
	csel	x2, x1, x2, gt
	mov	w1, 0
	add	x0, x4, x0, lsl 3
	bl	memset
.L108:
	ldr	x0, [sp, 144]
	cbz	x0, .L77
.L106:
	ldr	x0, [sp, 144]
	bl	_ZdlPv
	b	.L77
.L134:
	str	xzr, [sp, 144]
	str	wzr, [sp, 192]
	ldr	x0, [sp, 144]
	str	xzr, [sp, 176]
	ldr	w1, [sp, 192]
	str	xzr, [sp, 232]
	bl	_ZN12_GLOBAL__N_1L16simd_sum_squaresEPKdi
	fcmp	d0, #0.0
	bpl	.L148
	b	.L204
	.p2align 2,,3
.L149:
	ldr	x0, [sp, 144]
	fneg	d0, d8
	ldr	x1, [sp, 176]
	ldr	d1, [x0]
	fcmpe	d1, #0.0
	fcsel	d8, d8, d0, ge
	cbz	x1, .L135
	mov	x0, 9223372036854775800
	cmp	x1, x0
	bhi	.L205
	ldr	x0, [sp, 176]
.LEHB4:
	bl	_Znwm
.LEHE4:
	mov	x26, x0
.L89:
	ldr	x0, [sp, 144]
	ldr	x1, [sp, 232]
	cmp	x0, x1
	beq	.L91
	ldr	x2, [sp, 176]
	mov	x1, x0
	mov	x0, x26
	bl	memcpy
.L91:
	ldr	d0, [x26]
	mov	x0, x26
	ldr	w1, [sp, 192]
	fadd	d0, d0, d8
	str	d0, [x26]
	bl	_ZN12_GLOBAL__N_1L16simd_sum_squaresEPKdi
	fcmpe	d0, d10
	bgt	.L150
.L92:
	mov	x0, x26
	bl	_ZdlPv
	ldp	w0, w1, [sp, 136]
	add	w0, w0, 2
	cmp	w1, w0
	bgt	.L105
	b	.L106
.L128:
	mov	x21, 0
	mov	x19, 0
	b	.L34
.L127:
	mov	x3, 0
	b	.L30
.L147:
	ldp	w28, w0, [sp, 136]
	fmov	d4, 2.0e+0
	mov	x1, 1152921504606846975
	fdiv	d8, d4, d0
	sub	w0, w0, w28
	str	w0, [sp, 144]
	sxtw	x0, w0
	cmp	x0, x1
	bhi	.L206
	cbz	x0, .L133
	lsl	x2, x0, 3
	str	x2, [sp, 176]
	mov	x0, x2
.LEHB5:
	bl	_Znwm
.LEHE5:
	ldr	x2, [sp, 176]
	mov	x22, x0
	cbz	x2, .L62
	mov	w1, 0
	bl	memset
.L62:
	cmp	w21, 0
	ble	.L67
	ldr	w7, [sp, 136]
	mov	x9, x26
	ldr	w11, [sp, 144]
	mov	x10, x26
	mov	x0, x22
	add	w8, w7, w21
	.p2align 3,,7
.L66:
	ldr	w1, [x23, 4]
	mov	w2, w11
	ldr	x3, [x25]
	ldr	d0, [x10], 8
	mul	w1, w7, w1
	add	w7, w7, 1
	add	x1, x27, x1, sxtw
	add	x1, x3, x1, lsl 3
	bl	_ZN12_GLOBAL__N_1L15simd_add_scaledEPdPKddi
	cmp	w8, w7
	bne	.L66
	fneg	d4, d8
	ldr	w7, [sp, 144]
	mov	x1, x0
	.p2align 3,,7
.L68:
	ldr	w0, [x23, 4]
	mov	w2, w7
	ldr	d0, [x9], 8
	ldr	x3, [x25]
	mul	w0, w28, w0
	fmul	d0, d4, d0
	add	w28, w28, 1
	add	x0, x27, x0, sxtw
	add	x0, x3, x0, lsl 3
	bl	_ZN12_GLOBAL__N_1L15simd_add_scaledEPdPKddi
	cmp	w8, w28
	bne	.L68
	mov	x22, x1
.L67:
	ldr	x0, [sp, 184]
	cbz	x0, .L65
	ldr	x0, [sp, 208]
.LEHB6:
	bl	_Znwm
.LEHE6:
	ldr	x1, [sp, 208]
	mov	x28, x0
	cbz	x1, .L72
	ldr	x2, [sp, 208]
	mov	w1, 0
	bl	memset
.L72:
	cmp	w20, 0
	ble	.L70
	ldr	x8, [sp, 160]
	mov	x1, x26
	ldr	x9, [sp, 200]
	mov	w2, w21
	mov	x7, 0
	.p2align 3,,7
.L71:
	ldr	w0, [x8, 4]
	ldr	x3, [x9]
	mul	w0, w0, w7
	add	x0, x27, x0, sxtw
	add	x0, x3, x0, lsl 3
	bl	_ZN12_GLOBAL__N_1L8simd_dotEPKdS1_i
	str	d0, [x28, x7, lsl 3]
	add	x7, x7, 1
	cmp	w20, w7
	bgt	.L71
	fneg	d8, d8
	mov	w21, w2
	ldr	x8, [sp, 160]
	mov	x7, 0
	ldr	x9, [sp, 200]
	.p2align 3,,7
.L73:
	mov	w2, w21
	ldr	w0, [x8, 4]
	ldr	d0, [x28, x7, lsl 3]
	ldr	x3, [x9]
	mul	w0, w0, w7
	fmul	d0, d8, d0
	add	x7, x7, 1
	add	x0, x27, x0, sxtw
	add	x0, x3, x0, lsl 3
	bl	_ZN12_GLOBAL__N_1L15simd_add_scaledEPdPKddi
	cmp	w20, w7
	bgt	.L73
	mov	x26, x1
.L70:
	mov	x0, x28
	bl	_ZdlPv
.L65:
	cbz	x22, .L59
	mov	x0, x22
	bl	_ZdlPv
	b	.L59
.L135:
	mov	x26, 0
	b	.L89
.L133:
	mov	x22, 0
	b	.L62
.L150:
	ldr	x0, [sp, 128]
	fmov	d4, 2.0e+0
	fdiv	d8, d4, d0
	cbz	x0, .L136
	mov	x0, x24
.LEHB7:
	bl	_Znwm
.LEHE7:
	str	x0, [sp, 176]
	cbz	x24, .L94
	mov	x2, x24
	mov	w1, 0
	bl	memset
.L94:
	cmp	w21, 0
	ble	.L95
	ldr	x12, [sp, 176]
	add	x8, x27, 1
	mov	w7, w27
	add	w9, w21, w27
	mov	w11, w27
	mov	w2, w28
	mov	x1, x26
	mov	x10, x12
	.p2align 3,,7
.L96:
	ldr	w0, [x23, 4]
	ldr	x3, [x25]
	mul	w0, w11, w0
	add	w11, w11, 1
	add	x0, x8, x0, sxtw
	add	x0, x3, x0, lsl 3
	bl	_ZN12_GLOBAL__N_1L8simd_dotEPKdS1_i
	str	d0, [x12], 8
	cmp	w9, w11
	bne	.L96
	fneg	d4, d8
	mov	w28, w2
	.p2align 3,,7
.L97:
	ldr	w0, [x23, 4]
	mov	w2, w28
	ldr	d0, [x10], 8
	ldr	x3, [x25]
	mul	w0, w7, w0
	fmul	d0, d4, d0
	add	w7, w7, 1
	add	x0, x8, x0, sxtw
	add	x0, x3, x0, lsl 3
	bl	_ZN12_GLOBAL__N_1L15simd_add_scaledEPdPKddi
	cmp	w9, w7
	bne	.L97
	mov	x26, x1
.L95:
	ldr	x0, [sp, 216]
.LEHB8:
	bl	_Znwm
.LEHE8:
	ldr	x1, [sp, 216]
	mov	x24, x0
	cbz	x1, .L101
	ldr	x2, [sp, 216]
	mov	w1, 0
	bl	memset
.L101:
	ldr	w9, [sp, 140]
	add	x8, x27, 1
	ldr	x10, [sp, 168]
	mov	w2, w28
	ldr	x11, [sp, 224]
	mov	x1, x26
	mov	x7, 0
	.p2align 3,,7
.L102:
	ldr	w0, [x10, 4]
	ldr	x3, [x11]
	mul	w0, w0, w7
	add	x0, x8, x0, sxtw
	add	x0, x3, x0, lsl 3
	bl	_ZN12_GLOBAL__N_1L8simd_dotEPKdS1_i
	str	d0, [x24, x7, lsl 3]
	add	x7, x7, 1
	cmp	w9, w7
	bgt	.L102
	fneg	d8, d8
	ldr	w9, [sp, 140]
	ldr	x10, [sp, 168]
	mov	w28, w2
	ldr	x11, [sp, 224]
	mov	x7, 0
	.p2align 3,,7
.L103:
	ldr	w0, [x10, 4]
	mov	w2, w28
	ldr	d0, [x24, x7, lsl 3]
	ldr	x3, [x11]
	mul	w0, w0, w7
	fmul	d0, d8, d0
	add	x7, x7, 1
	add	x0, x8, x0, sxtw
	add	x0, x3, x0, lsl 3
	bl	_ZN12_GLOBAL__N_1L15simd_add_scaledEPdPKddi
	cmp	w9, w7
	bgt	.L103
	mov	x0, x24
	mov	x26, x1
	bl	_ZdlPv
	ldr	x0, [sp, 176]
	cbz	x0, .L92
	bl	_ZdlPv
	b	.L92
.L136:
	str	xzr, [sp, 176]
	b	.L94
.L203:
.LEHB9:
	bl	_ZSt17__throw_bad_allocv
.LEHE9:
.L205:
.LEHB10:
	bl	_ZSt17__throw_bad_allocv
.LEHE10:
	.p2align 2,,3
.L123:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
.LEHB11:
	bl	_ZSt20__throw_length_errorPKc
.LEHE11:
.L202:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
.LEHB12:
	bl	_ZSt20__throw_length_errorPKc
.LEHE12:
.L199:
.LEHB13:
	bl	_ZSt17__throw_bad_allocv
.LEHE13:
.L206:
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
.LEHB14:
	bl	_ZSt20__throw_length_errorPKc
.LEHE14:
.L138:
	mov	x20, x0
	b	.L121
.L139:
	mov	x20, x0
	cbz	x19, .L121
.L125:
	mov	x0, x19
	bl	_ZdlPv
.L121:
	ldr	x0, [x23, 8]
	cbz	x0, .L122
	bl	_ZdlPv
.L122:
	mov	x0, x20
.LEHB15:
	bl	_Unwind_Resume
.LEHE15:
.L141:
	mov	x20, x0
	cbz	x22, .L115
	mov	x0, x22
	bl	_ZdlPv
.L115:
	mov	x0, x26
	bl	_ZdlPv
	b	.L125
.L144:
	mov	x20, x0
	ldr	x0, [sp, 176]
	cbnz	x0, .L207
.L117:
	mov	x0, x26
	bl	_ZdlPv
.L118:
	ldr	x0, [sp, 144]
	bl	_ZdlPv
	cbnz	x19, .L125
	b	.L121
.L143:
	mov	x20, x0
	b	.L117
.L207:
	ldr	x0, [sp, 176]
	bl	_ZdlPv
	b	.L117
.L198:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 25
	.cfi_restore 26
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC0
	mov	x19, x0
	add	x1, x1, :lo12:.LC0
.LEHB16:
	bl	_ZNSt16invalid_argumentC1EPKc
.LEHE16:
	adrp	x2, _ZNSt16invalid_argumentD1Ev
	adrp	x1, _ZTISt16invalid_argument
	mov	x0, x19
	add	x2, x2, :lo12:_ZNSt16invalid_argumentD1Ev
	add	x1, x1, :lo12:_ZTISt16invalid_argument
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -184
	.cfi_offset 23, -192
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -168
	.cfi_offset 25, -176
.LEHB17:
	bl	__cxa_throw
.L145:
	mov	x20, x0
	b	.L125
.L137:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 25
	.cfi_restore 26
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -184
	.cfi_offset 23, -192
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -168
	.cfi_offset 25, -176
	bl	__cxa_free_exception
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE17:
.L142:
	mov	x20, x0
	b	.L118
.L140:
	mov	x20, x0
	b	.L115
	.cfi_endproc
.LFE7803:
	.global	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA7803:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE7803-.LLSDACSB7803
.LLSDACSB7803:
	.uleb128 .LEHB0-.LFB7803
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB7803
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L138-.LFB7803
	.uleb128 0
	.uleb128 .LEHB2-.LFB7803
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L139-.LFB7803
	.uleb128 0
	.uleb128 .LEHB3-.LFB7803
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L145-.LFB7803
	.uleb128 0
	.uleb128 .LEHB4-.LFB7803
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L142-.LFB7803
	.uleb128 0
	.uleb128 .LEHB5-.LFB7803
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L140-.LFB7803
	.uleb128 0
	.uleb128 .LEHB6-.LFB7803
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L141-.LFB7803
	.uleb128 0
	.uleb128 .LEHB7-.LFB7803
	.uleb128 .LEHE7-.LEHB7
	.uleb128 .L143-.LFB7803
	.uleb128 0
	.uleb128 .LEHB8-.LFB7803
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L144-.LFB7803
	.uleb128 0
	.uleb128 .LEHB9-.LFB7803
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L145-.LFB7803
	.uleb128 0
	.uleb128 .LEHB10-.LFB7803
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L142-.LFB7803
	.uleb128 0
	.uleb128 .LEHB11-.LFB7803
	.uleb128 .LEHE11-.LEHB11
	.uleb128 .L138-.LFB7803
	.uleb128 0
	.uleb128 .LEHB12-.LFB7803
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L139-.LFB7803
	.uleb128 0
	.uleb128 .LEHB13-.LFB7803
	.uleb128 .LEHE13-.LEHB13
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB14-.LFB7803
	.uleb128 .LEHE14-.LEHB14
	.uleb128 .L140-.LFB7803
	.uleb128 0
	.uleb128 .LEHB15-.LFB7803
	.uleb128 .LEHE15-.LEHB15
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB16-.LFB7803
	.uleb128 .LEHE16-.LEHB16
	.uleb128 .L137-.LFB7803
	.uleb128 0
	.uleb128 .LEHB17-.LFB7803
	.uleb128 .LEHE17-.LEHB17
	.uleb128 0
	.uleb128 0
.LLSDACSE7803:
	.text
	.size	_Z13to_bidiagonalRK6MatrixRS_S2_, .-_Z13to_bidiagonalRK6MatrixRS_S2_
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.type	_GLOBAL__sub_I__Z13to_bidiagonalRK6MatrixRS_S2_, %function
_GLOBAL__sub_I__Z13to_bidiagonalRK6MatrixRS_S2_:
.LFB8372:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	adrp	x19, .LANCHOR0
	add	x19, x19, :lo12:.LANCHOR0
	mov	x0, x19
	bl	_ZNSt8ios_base4InitC1Ev
	mov	x1, x19
	adrp	x2, __dso_handle
	ldr	x19, [sp, 16]
	add	x2, x2, :lo12:__dso_handle
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	adrp	x0, _ZNSt8ios_base4InitD1Ev
	add	x0, x0, :lo12:_ZNSt8ios_base4InitD1Ev
	b	__cxa_atexit
	.cfi_endproc
.LFE8372:
	.size	_GLOBAL__sub_I__Z13to_bidiagonalRK6MatrixRS_S2_, .-_GLOBAL__sub_I__Z13to_bidiagonalRK6MatrixRS_S2_
	.section	.init_array,"aw"
	.align	3
	.xword	_GLOBAL__sub_I__Z13to_bidiagonalRK6MatrixRS_S2_
	.section	.rodata.cst8,"aM",@progbits,8
	.align	3
.LC2:
	.word	-2036257893
	.word	1023837339
	.align	3
.LC3:
	.word	-1102028775
	.word	975155446
	.bss
	.align	3
	.set	.LANCHOR0,. + 0
	.type	_ZStL8__ioinit, %object
	.size	_ZStL8__ioinit, 1
_ZStL8__ioinit:
	.zero	1
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align	3
	.type	DW.ref.__gxx_personality_v0, %object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.xword	__gxx_personality_v0
	.hidden	__dso_handle
	.ident	"GCC: (GNU) 10.3.1"
	.section	.note.GNU-stack,"",@progbits
