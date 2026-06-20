	.arch armv8-a
	.file	"gkh.cpp"
	.text
	.align	2
	.p2align 4,,11
	.type	_ZN12_GLOBAL__N_1L15apply_left_rowsER6Matrixiidd, %function
_ZN12_GLOBAL__N_1L15apply_left_rowsER6Matrixiidd:
.LFB3744:
	.cfi_startproc
	ldr	w4, [x0, 4]
	cmp	w4, 0
	ble	.L1
	mul	w1, w1, w4
	sub	w3, w4, #1
	mul	w2, w2, w4
	ldr	x0, [x0, 8]
	sxtw	x4, w1
	add	x3, x3, x4
	sxtw	x2, w2
	add	x5, x0, 8
	sub	x2, x2, x4
	add	x0, x0, x1, sxtw 3
	add	x1, x5, x3, lsl 3
	.p2align 3,,7
.L3:
	ldr	d2, [x0, x2, lsl 3]
	ldr	d4, [x0]
	fmul	d3, d2, d1
	fmul	d2, d2, d0
	fmadd	d3, d4, d0, d3
	fmsub	d2, d1, d4, d2
	str	d3, [x0]
	str	d2, [x0, x2, lsl 3]
	add	x0, x0, 8
	cmp	x1, x0
	bne	.L3
.L1:
	ret
	.cfi_endproc
.LFE3744:
	.size	_ZN12_GLOBAL__N_1L15apply_left_rowsER6Matrixiidd, .-_ZN12_GLOBAL__N_1L15apply_left_rowsER6Matrixiidd
	.align	2
	.p2align 4,,11
	.type	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd, %function
_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd:
.LFB3745:
	.cfi_startproc
	ldr	w5, [x0]
	cmp	w5, 0
	ble	.L7
	ldr	x6, [x0, 8]
	sxtw	x2, w2
	ldrsw	x4, [x0, 4]
	sub	x3, x2, x1, sxtw
	mov	w2, 0
	add	x0, x6, x1, sxtw 3
	lsl	x1, x4, 3
	.p2align 3,,7
.L9:
	ldr	d2, [x0, x3, lsl 3]
	add	w2, w2, 1
	ldr	d4, [x0]
	fmul	d3, d2, d1
	fmul	d2, d2, d0
	fnmsub	d3, d4, d0, d3
	fmadd	d2, d4, d1, d2
	str	d3, [x0]
	str	d2, [x0, x3, lsl 3]
	add	x0, x0, x1
	cmp	w2, w5
	bne	.L9
.L7:
	ret
	.cfi_endproc
.LFE3745:
	.size	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd, .-_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	.align	2
	.p2align 4,,11
	.type	_ZN12_GLOBAL__N_1L18cleanup_bidiagonalER6Matrixd, %function
_ZN12_GLOBAL__N_1L18cleanup_bidiagonalER6Matrixd:
.LFB3748:
	.cfi_startproc
	ldr	w8, [x0]
	cmp	w8, 0
	ble	.L11
	ldr	w5, [x0, 4]
	mov	w4, 0
	mov	w3, 0
	mov	w7, 0
	.p2align 3,,7
.L14:
	add	w7, w7, 1
	mov	w1, 0
	cmp	w5, 0
	ble	.L18
	.p2align 3,,7
.L13:
	add	w2, w1, w4
	cmp	w3, w1
	beq	.L16
	sxtw	x2, w2
	cmp	w1, w7
	beq	.L16
	ldr	x6, [x0, 8]
	ldr	d1, [x6, x2, lsl 3]
	fabs	d1, d1
	fcmpe	d1, d0
	bls	.L20
.L16:
	add	w1, w1, 1
	cmp	w1, w5
	bne	.L13
.L18:
	add	w3, w3, 1
	add	w4, w4, w5
	cmp	w8, w7
	bne	.L14
.L11:
	ret
	.p2align 2,,3
.L20:
	str	xzr, [x6, x2, lsl 3]
	b	.L16
	.cfi_endproc
.LFE3748:
	.size	_ZN12_GLOBAL__N_1L18cleanup_bidiagonalER6Matrixd, .-_ZN12_GLOBAL__N_1L18cleanup_bidiagonalER6Matrixd
	.align	2
	.p2align 4,,11
	.type	_ZNSt6vectorIdSaIdEEaSERKS1_.isra.0, %function
_ZNSt6vectorIdSaIdEEaSERKS1_.isra.0:
.LFB4575:
	.cfi_startproc
	cmp	x1, x0
	beq	.L44
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	ldp	x23, x24, [x1]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x20, x1
	ldr	x22, [x0]
	sub	x21, x24, x23
	ldr	x0, [x0, 16]
	sub	x0, x0, x22
	cmp	x21, x0
	bhi	.L48
	ldr	x0, [x19, 8]
	sub	x2, x0, x22
	cmp	x21, x2
	bhi	.L32
	cmp	x24, x23
	beq	.L47
	mov	x0, x22
	mov	x1, x23
	mov	x2, x21
	bl	memmove
	ldr	x22, [x19]
.L47:
	add	x21, x22, x21
	ldp	x23, x24, [sp, 48]
	str	x21, [x19, 8]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L48:
	.cfi_restore_state
	cbz	x21, .L36
	mov	x0, 9223372036854775800
	cmp	x21, x0
	bhi	.L49
	mov	x0, x21
	bl	_Znwm
	ldr	x22, [x19]
	mov	x20, x0
.L27:
	cmp	x24, x23
	beq	.L29
	mov	x1, x23
	mov	x2, x21
	mov	x0, x20
	bl	memcpy
.L29:
	cbz	x22, .L30
	mov	x0, x22
	bl	_ZdlPv
.L30:
	add	x21, x20, x21
	str	x20, [x19]
	str	x21, [x19, 16]
	ldp	x23, x24, [sp, 48]
	str	x21, [x19, 8]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L44:
	ret
	.p2align 2,,3
.L32:
	.cfi_def_cfa_offset 64
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	cbz	x2, .L34
	mov	x1, x23
	mov	x0, x22
	bl	memmove
	ldp	x22, x0, [x19]
	ldp	x23, x24, [x20]
	sub	x2, x0, x22
.L34:
	add	x1, x23, x2
	cmp	x1, x24
	beq	.L47
	sub	x2, x24, x1
	bl	memmove
	ldr	x0, [x19]
	ldp	x23, x24, [sp, 48]
	add	x21, x0, x21
	str	x21, [x19, 8]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L36:
	.cfi_restore_state
	mov	x20, 0
	b	.L27
.L49:
	bl	_ZSt17__throw_bad_allocv
	.cfi_endproc
.LFE4575:
	.size	_ZNSt6vectorIdSaIdEEaSERKS1_.isra.0, .-_ZNSt6vectorIdSaIdEEaSERKS1_.isra.0
	.align	2
	.p2align 4,,11
	.type	_ZSt16__insertion_sortIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEENS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_, %function
_ZSt16__insertion_sortIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEENS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_:
.LFB4429:
	.cfi_startproc
	cmp	x0, x1
	beq	.L67
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	add	x20, x0, 4
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	mov	x23, x0
	mov	x24, x1
	cmp	x20, x1
	beq	.L50
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -40
	.cfi_offset 21, -48
	mov	x21, x2
	mov	x22, 4
	str	x25, [sp, 64]
	.cfi_offset 25, -16
	add	x25, x2, 8
	.p2align 3,,7
.L60:
	ldr	w7, [x21, 4]
	mov	x2, x20
	ldr	w19, [x20]
	ldr	w3, [x23]
	ldr	x6, [x25]
	madd	w0, w19, w7, w19
	madd	w3, w3, w7, w3
	ldr	d0, [x6, w0, sxtw 3]
	ldr	d1, [x6, w3, sxtw 3]
	fcmpe	d0, d1
	bgt	.L61
	ldr	w4, [x20, -4]
	sub	x5, x20, #4
	madd	w7, w7, w4, w4
	ldr	d1, [x6, w7, sxtw 3]
	fcmpe	d0, d1
	bgt	.L59
	.p2align 3,,7
.L57:
	str	w19, [x2]
.L56:
	add	x20, x20, 4
	cmp	x20, x24
	bne	.L60
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldr	x25, [sp, 64]
	.cfi_restore 25
.L50:
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L59:
	.cfi_def_cfa_offset 80
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.cfi_offset 25, -16
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	str	w4, [x5, 4]
	mov	x2, x5
	ldr	w4, [x5, -4]!
	ldr	w3, [x21, 4]
	madd	w7, w19, w3, w19
	madd	w3, w4, w3, w4
	ldr	d1, [x6, w7, sxtw 3]
	ldr	d0, [x6, w3, sxtw 3]
	fcmpe	d1, d0
	bgt	.L59
	b	.L57
	.p2align 2,,3
.L61:
	cmp	x23, x20
	beq	.L55
	sub	x2, x20, x23
	mov	x1, x23
	add	x0, x23, x22
	bl	memmove
.L55:
	str	w19, [x23]
	b	.L56
.L67:
	.cfi_def_cfa_offset 0
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 25
	.cfi_restore 29
	.cfi_restore 30
	ret
	.cfi_endproc
.LFE4429:
	.size	_ZSt16__insertion_sortIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEENS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_, .-_ZSt16__insertion_sortIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEENS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_
	.align	2
	.p2align 4,,11
	.type	_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEEliNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_T0_SF_T1_T2_, %function
_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEEliNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_T0_SF_T1_T2_:
.LFB4543:
	.cfi_startproc
	sub	x14, x2, #1
	and	x16, x2, 1
	add	x14, x14, x14, lsr 63
	asr	x14, x14, 1
	cmp	x1, x14
	bge	.L71
	ldr	x12, [x4, 8]
	mov	x10, x1
	.p2align 3,,7
.L74:
	add	x6, x10, 1
	ldr	w7, [x4, 4]
	lsl	x5, x6, 1
	lsl	x6, x6, 3
	sub	x8, x5, #1
	add	x11, x0, x6
	ldr	w6, [x0, x6]
	add	x15, x0, x8, lsl 2
	ldr	w9, [x0, x8, lsl 2]
	madd	w13, w6, w7, w6
	madd	w7, w9, w7, w9
	ldr	d1, [x12, w13, sxtw 3]
	ldr	d0, [x12, w7, sxtw 3]
	fcmpe	d1, d0
	bgt	.L82
.L72:
	str	w6, [x0, x10, lsl 2]
	mov	x10, x5
	cmp	x5, x14
	blt	.L74
	cbz	x16, .L79
.L75:
	sub	x6, x5, #1
	add	x6, x6, x6, lsr 63
	asr	x6, x6, 1
	cmp	x5, x1
	ble	.L76
	ldr	x9, [x4, 8]
	.p2align 3,,7
.L78:
	sub	x2, x6, #1
	ldr	w7, [x4, 4]
	add	x12, x0, x6, lsl 2
	ldr	w8, [x0, x6, lsl 2]
	add	x2, x2, x2, lsr 63
	add	x11, x0, x5, lsl 2
	asr	x2, x2, 1
	madd	w10, w8, w7, w8
	madd	w7, w3, w7, w3
	ldr	d1, [x9, w10, sxtw 3]
	ldr	d0, [x9, w7, sxtw 3]
	fcmpe	d1, d0
	bgt	.L83
.L76:
	str	w3, [x11]
	ret
	.p2align 2,,3
.L83:
	str	w8, [x0, x5, lsl 2]
	mov	x5, x6
	cmp	x1, x6
	bge	.L85
	mov	x6, x2
	b	.L78
	.p2align 2,,3
.L71:
	add	x11, x0, x1, lsl 2
	mov	x5, x1
	cbnz	x16, .L76
	.p2align 3,,7
.L79:
	sub	x2, x2, #2
	add	x2, x2, x2, lsr 63
	cmp	x5, x2, asr 1
	bne	.L75
	lsl	x5, x5, 1
	add	x5, x5, 1
	ldr	w2, [x0, x5, lsl 2]
	str	w2, [x11]
	add	x11, x0, x5, lsl 2
	b	.L75
	.p2align 2,,3
.L82:
	mov	x11, x15
	mov	w6, w9
	mov	x5, x8
	b	.L72
	.p2align 2,,3
.L85:
	mov	x11, x12
	str	w3, [x11]
	ret
	.cfi_endproc
.LFE4543:
	.size	_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEEliNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_T0_SF_T1_T2_, .-_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEEliNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_T0_SF_T1_T2_
	.align	2
	.p2align 4,,11
	.type	_ZSt16__introsort_loopIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEElNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_T1_, %function
_ZSt16__introsort_loopIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEElNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_T1_:
.LFB4355:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	mov	x24, x0
	sub	x0, x1, x0
	cmp	x0, 64
	ble	.L86
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -8
	.cfi_offset 25, -16
	mov	x23, x1
	mov	x26, x2
	mov	x25, x3
	cbz	x2, .L88
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -56
	.cfi_offset 19, -64
	add	x20, x24, 8
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -40
	.cfi_offset 21, -48
	add	x22, x24, 4
	add	x21, x3, 8
.L90:
	sub	x0, x1, x24
	ldr	w3, [x25, 4]
	ldr	w5, [x1, -4]
	sub	x26, x26, #1
	lsr	x4, x0, 63
	add	x0, x4, x0, asr 2
	ldp	w10, w2, [x24]
	asr	x0, x0, 1
	madd	w6, w3, w5, w5
	ldr	x9, [x21]
	madd	w7, w2, w3, w2
	ldr	w4, [x24, x0, lsl 2]
	ldr	d2, [x9, w6, sxtw 3]
	ldr	d1, [x9, w7, sxtw 3]
	madd	w3, w4, w3, w4
	ldr	d0, [x9, w3, sxtw 3]
	fcmpe	d1, d0
	bgt	.L117
	fcmpe	d1, d2
	bgt	.L120
	fcmpe	d0, d2
	bgt	.L121
.L135:
	str	w4, [x24]
	str	w10, [x24, x0, lsl 2]
	ldr	w3, [x1, -4]
	ldp	w2, w10, [x24]
.L99:
	mov	x11, x20
	ldr	w7, [x25, 4]
	mov	x19, x22
	mov	x8, x1
	madd	w2, w2, w7, w2
	ldr	d1, [x9, w2, sxtw 3]
	.p2align 3,,7
.L106:
	madd	w0, w10, w7, w10
	mov	x23, x19
	ldr	d0, [x9, w0, sxtw 3]
	fcmpe	d0, d1
	bgt	.L109
	madd	w0, w3, w7, w3
	sub	x4, x8, #4
	sub	x5, x8, #8
	ldr	d0, [x9, w0, sxtw 3]
	fcmpe	d1, d0
	bgt	.L112
	mov	x8, x4
	cmp	x8, x19
	bls	.L140
	.p2align 3,,7
.L113:
	str	w3, [x19]
	str	w10, [x8]
	ldr	w3, [x8, -4]
	ldr	w0, [x24]
	ldr	w7, [x25, 4]
	madd	w0, w0, w7, w0
	ldr	d1, [x9, w0, sxtw 3]
.L109:
	ldr	w10, [x11], 4
	add	x19, x19, 4
	b	.L106
	.p2align 2,,3
.L112:
	mov	x8, x5
	ldr	w3, [x5], -4
	madd	w6, w3, w7, w3
	ldr	d0, [x9, w6, sxtw 3]
	fcmpe	d0, d1
	bmi	.L112
	cmp	x8, x19
	bhi	.L113
.L140:
	mov	x0, x19
	mov	x3, x25
	mov	x2, x26
	bl	_ZSt16__introsort_loopIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEElNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_T1_
	sub	x0, x19, x24
	cmp	x0, 64
	ble	.L141
	cbz	x26, .L138
	mov	x1, x19
	b	.L90
.L121:
	str	w5, [x24]
	mov	w3, w10
	str	w10, [x1, -4]
	ldp	w2, w10, [x24]
	b	.L99
.L117:
	fcmpe	d0, d2
	bgt	.L135
	fcmpe	d1, d2
	bgt	.L121
.L120:
	stp	w2, w10, [x24]
	ldr	w3, [x1, -4]
	b	.L99
.L141:
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
.L86:
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_def_cfa_offset 0
	ret
.L138:
	.cfi_def_cfa_offset 80
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 23, -32
	.cfi_offset 24, -24
	.cfi_offset 25, -16
	.cfi_offset 26, -8
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
.L88:
	asr	x18, x0, 2
	sub	x1, x18, #2
	asr	x1, x1, 1
	b	.L92
.L142:
	sub	x1, x1, #1
.L92:
	ldr	w3, [x24, x1, lsl 2]
	mov	x4, x25
	mov	x2, x18
	mov	x0, x24
	bl	_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEEliNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_T0_SF_T1_T2_
	cbnz	x1, .L142
	sub	x23, x23, #4
	.p2align 3,,7
.L93:
	ldr	w3, [x23]
	sub	x18, x23, x24
	ldr	w0, [x24]
	mov	x4, x25
	str	w0, [x23]
	asr	x2, x18, 2
	mov	x0, x24
	mov	x1, 0
	bl	_ZSt13__adjust_heapIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEEliNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_T0_SF_T1_T2_
	sub	x23, x23, #4
	cmp	x18, 4
	bgt	.L93
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	b	.L86
	.cfi_endproc
.LFE4355:
	.size	_ZSt16__introsort_loopIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEElNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_T1_, .-_ZSt16__introsort_loopIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEElNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_T1_
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"gkh_svd_from_bidiagonal_v2: requires m >= n"
	.align	3
.LC1:
	.string	"gkh_svd_from_bidiagonal_v2: U must be m x m"
	.align	3
.LC2:
	.string	"gkh_svd_from_bidiagonal_v2: V must be n x n"
	.align	3
.LC3:
	.string	"vector::_M_realloc_insert"
	.align	3
.LC4:
	.string	"cannot create std::vector larger than max_size()"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id
	.type	_Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id, %function
_Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id:
.LFB3775:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA3775
	stp	x29, x30, [sp, -288]!
	.cfi_def_cfa_offset 288
	.cfi_offset 29, -288
	.cfi_offset 30, -280
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -272
	.cfi_offset 20, -264
	mov	x20, x1
	ldr	w1, [x1]
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -224
	.cfi_offset 26, -216
	mov	x25, x0
	ldr	w0, [x20, 4]
	str	w0, [sp, 152]
	str	w3, [sp, 188]
	cmp	w1, w0
	blt	.L346
	ldr	w0, [x25]
	cmp	w0, w1
	bne	.L145
	ldr	w1, [x25, 4]
	cmp	w1, w0
	bne	.L145
	ldr	w0, [x2]
	ldr	w1, [sp, 152]
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -232
	.cfi_offset 23, -240
	mov	x24, x2
	cmp	w0, w1
	bne	.L148
	ldr	w0, [x2, 4]
	ldr	w1, [sp, 152]
	cmp	w0, w1
	bne	.L148
	ldr	w0, [sp, 152]
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -248
	.cfi_offset 21, -256
	sub	w21, w0, #1
	ldr	w0, [sp, 188]
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -200
	.cfi_offset 27, -208
	stp	d8, d9, [sp, 96]
	.cfi_offset 73, -184
	.cfi_offset 72, -192
	fmov	d8, d0
	str	wzr, [sp, 184]
	cmp	w0, 0
	ble	.L203
	mov	x1, 10
	mov	x0, -9223372036854775808
	movk	x1, 0x3ff0, lsl 48
	fmov	d9, x0
	stp	d10, d11, [sp, 112]
	.cfi_offset 75, -168
	.cfi_offset 74, -176
	fmov	d10, x1
	stp	d12, d13, [sp, 128]
	.cfi_offset 77, -152
	.cfi_offset 76, -160
	.p2align 3,,7
.L151:
	fmov	d0, d8
	mov	x0, x20
	add	x23, x20, 8
	mov	w28, 0
	bl	_ZN12_GLOBAL__N_1L18cleanup_bidiagonalER6Matrixd
	ldr	w19, [x20, 4]
	fmul	d13, d8, d10
	sub	w22, w19, #1
	cmp	w22, 0
	bgt	.L153
	b	.L164
	.p2align 2,,3
.L347:
	ldr	w19, [x20, 4]
	mov	w28, w26
.L153:
	mul	w0, w19, w28
	add	w27, w28, 1
	ldr	x1, [x23]
	add	w4, w0, w28
	mov	w26, w27
	ldr	d11, [x1, w4, sxtw 3]
	fabs	d0, d11
	fcmpe	d8, d0
	bge	.L286
.L156:
	cmp	w22, w26
	bne	.L347
.L164:
	cmp	w21, 0
	ble	.L154
	ldr	w3, [x20, 4]
	mov	w2, 0
	ldr	x1, [x20, 8]
	add	w3, w3, 1
	fmov	d3, 1.0e+0
	sbfiz	x3, x3, 3, 32
	add	x0, x1, 8
	add	x1, x1, x3
	.p2align 3,,7
.L155:
	ldp	d0, d1, [x0, -8]
	add	w2, w2, 1
	ldr	d2, [x1]
	fabs	d0, d0
	fabs	d1, d1
	fabs	d2, d2
	fadd	d0, d0, d2
	fadd	d0, d0, d3
	fmul	d0, d0, d8
	fcmpe	d0, d1
	bge	.L288
.L165:
	add	x1, x1, x3
	add	x0, x0, x3
	cmp	w2, w21
	bne	.L155
.L154:
	ldr	w0, [sp, 152]
	cmp	w0, 0
	ble	.L260
	mov	x27, 0
	mov	x4, 0
	mov	x3, 0
	mov	w22, 0
	mov	x28, 1152921504606846975
	.p2align 3,,7
.L181:
	mov	w19, w22
	.p2align 3,,7
.L169:
	cmp	w19, w21
	bge	.L168
	ldr	w0, [x20, 4]
	add	w1, w19, 1
	ldr	x2, [x20, 8]
	madd	w0, w19, w0, w1
	ldr	d0, [x2, w0, sxtw 3]
	fabs	d0, d0
	fcmpe	d0, #0.0
	bgt	.L266
.L168:
	cmp	x4, x3
	beq	.L170
	stp	w22, w19, [x3]
	add	x3, x3, 8
.L171:
	ldr	w0, [sp, 152]
	add	w22, w19, 1
	cmp	w0, w22
	bgt	.L181
	cmp	x27, x3
	beq	.L186
	mov	x0, x27
	b	.L185
	.p2align 2,,3
.L348:
	add	x0, x0, 8
	cmp	x3, x0
	beq	.L186
.L185:
	ldp	w1, w2, [x0]
	cmp	w2, w1
	ble	.L348
	sub	x0, x3, x27
	asr	x0, x0, 3
	cmp	w0, 0
	ble	.L188
	sub	w1, w0, #1
	sbfiz	x0, x0, 3, 32
	sub	x22, x0, #8
	fmov	d12, 2.5e-1
	sub	x0, x0, x1, uxtw 3
	sub	x1, x27, #16
	add	x0, x0, x1
	add	x22, x27, x22
	str	x0, [sp, 160]
	b	.L189
	.p2align 2,,3
.L198:
	ldr	x0, [sp, 160]
	sub	x22, x22, #8
	cmp	x0, x22
	beq	.L188
.L189:
	ldp	w19, w28, [x22]
	cmp	w28, w19
	ble	.L198
	ldr	w0, [x20, 4]
	sub	w5, w28, #1
	ldr	x3, [x20, 8]
	movi	d1, #0
	add	x23, x20, 8
	mul	w2, w5, w0
	add	w4, w0, w2
	add	w7, w5, w2
	add	w6, w28, w4
	add	w2, w28, w2
	ldr	d0, [x3, w7, sxtw 3]
	ldr	d11, [x3, w6, sxtw 3]
	ldr	d2, [x3, w2, sxtw 3]
	cmp	w19, w5
	bge	.L190
	sub	w2, w4, w0, lsl 1
	add	w2, w2, w5
	ldr	d1, [x3, w2, sxtw 3]
	fmul	d1, d1, d1
.L190:
	fmul	d3, d2, d2
	fmadd	d1, d0, d0, d1
	fmadd	d11, d11, d11, d3
	fmul	d0, d0, d2
	fmul	d0, d0, d0
	fadd	d13, d1, d11
	fnmsub	d0, d1, d11, d0
	fmul	d1, d13, d12
	fnmsub	d0, d13, d1, d0
	fcmpe	d0, #0.0
	bmi	.L270
	fcmp	d0, #0.0
	bpl	.L191
	bl	sqrt
	ldr	w0, [x20, 4]
	ldr	x3, [x20, 8]
	b	.L194
	.p2align 2,,3
.L266:
	mov	w19, w1
	b	.L169
.L270:
	movi	d0, #0
.L191:
	fsqrt	d0, d0
.L194:
	fmov	d1, 5.0e-1
	mul	w0, w19, w0
	add	w26, w19, 1
	fmadd	d3, d13, d1, d0
	fnmsub	d0, d13, d1, d0
	add	w4, w19, w0
	add	w0, w0, w26
	ldr	d2, [x3, w4, sxtw 3]
	ldr	d13, [x3, w0, sxtw 3]
	fabd	d1, d3, d11
	fabd	d11, d0, d11
	fmul	d13, d2, d13
	fcmpe	d1, d11
	fmov	d1, d13
	fcsel	d3, d3, d0, ls
	fnmsub	d11, d2, d2, d3
	fmov	d0, d11
	bl	hypot
	fcmp	d0, #0.0
	fmov	d2, d0
	beq	.L271
	fdiv	d0, d11, d0
	fneg	d1, d13
	fdiv	d1, d1, d2
.L196:
	mov	w2, w26
	mov	w1, w19
	mov	x0, x20
	bl	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	mov	w2, w26
	mov	w1, w19
	mov	x0, x24
	bl	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	ldr	w0, [x20, 4]
	ldr	x4, [x20, 8]
	mul	w3, w19, w0
	add	w0, w0, w3
	add	w3, w19, w3
	add	w0, w0, w19
	ldr	d13, [x4, w3, sxtw 3]
	ldr	d11, [x4, w0, sxtw 3]
	fmov	d0, d13
	fmov	d1, d11
	bl	hypot
	fcmp	d0, #0.0
	beq	.L272
	fdiv	d1, d11, d0
	fdiv	d0, d13, d0
	fneg	d5, d1
.L197:
	mov	w2, w26
	mov	w1, w19
	mov	x0, x20
	bl	_ZN12_GLOBAL__N_1L15apply_left_rowsER6Matrixiidd
	fmov	d1, d5
	mov	w2, w26
	mov	w1, w19
	mov	x0, x25
	bl	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	cmp	w28, w26
	bgt	.L201
	b	.L198
	.p2align 2,,3
.L349:
	fdiv	d0, d13, d0
	fneg	d1, d11
	fdiv	d1, d1, d2
.L199:
	mov	w2, w26
	mov	w1, w19
	mov	x0, x20
	bl	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	mov	w2, w26
	mov	w1, w19
	mov	x0, x24
	bl	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	ldr	w0, [x20, 4]
	ldr	x4, [x23]
	mul	w3, w0, w19
	add	w0, w0, w3
	add	w3, w3, w19
	add	w0, w0, w19
	ldr	d13, [x4, w3, sxtw 3]
	ldr	d11, [x4, w0, sxtw 3]
	fmov	d0, d13
	fmov	d1, d11
	bl	hypot
	fcmp	d0, #0.0
	beq	.L274
	fdiv	d1, d11, d0
	fdiv	d0, d13, d0
	fneg	d5, d1
.L200:
	mov	w2, w26
	mov	w1, w19
	mov	x0, x20
	bl	_ZN12_GLOBAL__N_1L15apply_left_rowsER6Matrixiidd
	fmov	d1, d5
	mov	w2, w26
	mov	w1, w19
	mov	x0, x25
	bl	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	cmp	w28, w26
	beq	.L198
.L201:
	ldr	w4, [x20, 4]
	sub	w0, w26, #1
	mov	w19, w26
	ldr	x3, [x23]
	mul	w0, w0, w4
	add	w4, w0, w26
	add	w26, w26, 1
	add	w0, w0, w26
	ldr	d13, [x3, w4, sxtw 3]
	ldr	d11, [x3, w0, sxtw 3]
	fmov	d0, d13
	fmov	d1, d11
	bl	hypot
	fcmp	d0, #0.0
	fmov	d2, d0
	bne	.L349
	movi	d1, #0
	fmov	d0, 1.0e+0
	b	.L199
	.p2align 2,,3
.L288:
	str	xzr, [x0]
	b	.L165
	.p2align 2,,3
.L286:
	add	w0, w0, w27
	ldr	d12, [x1, w0, sxtw 3]
	fabs	d0, d12
	fcmpe	d13, d0
	bmi	.L287
	b	.L156
	.p2align 2,,3
.L287:
	sub	w19, w19, #1
	cmp	w19, w28
	ble	.L156
	fcmpe	d8, d0
	bge	.L156
	ldr	w0, [x20]
	str	w0, [sp, 160]
	b	.L159
	.p2align 2,,3
.L351:
	fdiv	d0, d11, d0
	fneg	d1, d12
	fdiv	d1, d1, d2
.L161:
	mov	w2, w27
	mov	w1, w28
	mov	x0, x20
	bl	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	mov	x0, x24
	mov	w2, w27
	mov	w1, w28
	bl	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	ldr	w0, [sp, 160]
	cmp	w0, w27
	bgt	.L350
	cmp	w19, w27
	beq	.L160
.L355:
	ldr	w0, [x20, 4]
	add	w1, w28, 2
	ldr	x4, [x23]
	mov	w28, w27
	mul	w0, w27, w0
	add	w1, w1, w0
	add	w0, w27, w0
	add	w27, w27, 1
	ldr	d11, [x4, w0, sxtw 3]
	ldr	d12, [x4, w1, sxtw 3]
.L159:
	fmov	d1, d12
	fmov	d0, d11
	bl	hypot
	fcmp	d0, #0.0
	fmov	d2, d0
	bne	.L351
	movi	d1, #0
	fmov	d0, 1.0e+0
	b	.L161
	.p2align 2,,3
.L274:
	movi	d1, #0
	fmov	d5, d9
	fmov	d0, 1.0e+0
	b	.L200
	.p2align 2,,3
.L170:
	sub	x23, x4, x27
	asr	x0, x23, 3
	cmp	x0, x28
	beq	.L352
	cmp	x0, 0
	csinc	x1, x0, xzr, ne
	adds	x0, x0, x1
	bcs	.L174
	cbz	x0, .L353
	cmp	x0, x28
	csel	x0, x0, x28, ls
	lsl	x0, x0, 3
.L175:
	mov	x26, x0
.LEHB0:
	bl	_Znwm
.LEHE0:
	mov	x5, x0
	add	x4, x0, x26
.L176:
	add	x0, x5, x23
	str	w22, [x5, x23]
	add	x3, x23, 8
	add	x3, x5, x3
	str	w19, [x0, 4]
	cmp	x23, 0
	bgt	.L354
	cbnz	x27, .L178
	mov	x27, x5
	b	.L171
.L354:
	mov	x0, x5
	mov	x2, x23
	mov	x1, x27
	stp	x4, x3, [sp, 160]
	bl	memmove
	ldp	x4, x3, [sp, 160]
	mov	x5, x0
.L178:
	mov	x0, x27
	stp	x5, x4, [sp, 160]
	str	x3, [sp, 176]
	bl	_ZdlPv
	ldp	x5, x4, [sp, 160]
	ldr	x3, [sp, 176]
	mov	x27, x5
	b	.L171
	.p2align 2,,3
.L350:
	ldr	w0, [x20, 4]
	ldr	x4, [x23]
	mul	w1, w0, w28
	add	w0, w0, w1
	add	w1, w1, w28
	add	w0, w0, w28
	ldr	d12, [x4, w1, sxtw 3]
	ldr	d11, [x4, w0, sxtw 3]
	fmov	d0, d12
	fmov	d1, d11
	bl	hypot
	fcmp	d0, #0.0
	beq	.L264
	fdiv	d1, d11, d0
	fdiv	d0, d12, d0
	fneg	d5, d1
.L163:
	mov	w2, w27
	mov	w1, w28
	mov	x0, x20
	bl	_ZN12_GLOBAL__N_1L15apply_left_rowsER6Matrixiidd
	fmov	d1, d5
	mov	w2, w27
	mov	w1, w28
	mov	x0, x25
	bl	_ZN12_GLOBAL__N_1L16apply_right_colsER6Matrixiidd
	cmp	w19, w27
	bne	.L355
.L160:
	fmov	d0, d8
	mov	x0, x20
	bl	_ZN12_GLOBAL__N_1L18cleanup_bidiagonalER6Matrixd
	b	.L156
	.p2align 2,,3
.L188:
	cbz	x27, .L202
	mov	x0, x27
	bl	_ZdlPv
.L202:
	ldp	w0, w1, [sp, 184]
	add	w0, w0, 1
	str	w0, [sp, 184]
	cmp	w1, w0
	bne	.L151
	ldp	d10, d11, [sp, 112]
	.cfi_restore 75
	.cfi_restore 74
	ldp	d12, d13, [sp, 128]
	.cfi_restore 77
	.cfi_restore 76
.L203:
	fmov	d0, d8
	mov	x0, x20
	mov	w23, 0
	bl	_ZN12_GLOBAL__N_1L18cleanup_bidiagonalER6Matrixd
	ldr	w19, [x20, 4]
	cmp	w21, 0
	ble	.L204
.L360:
	sxtw	x7, w19
	mov	w1, 0
	ldr	x0, [x20, 8]
	add	x2, x7, 1
	add	x0, x0, 8
	lsl	x2, x2, 3
	.p2align 3,,7
.L206:
	add	w1, w1, 1
	str	xzr, [x0]
	add	x0, x0, x2
	cmp	w1, w21
	bne	.L206
	ldr	w5, [x20]
	cmp	w19, 0
	ble	.L207
.L361:
	add	x6, x7, 1
	add	x22, x25, 8
	ldr	x3, [x20, 8]
	lsl	x6, x6, 3
	mov	x2, 0
	.p2align 3,,7
.L210:
	ldr	d0, [x3]
	fcmpe	d0, #0.0
	bmi	.L208
.L211:
	add	x2, x2, 1
	add	x3, x3, x6
	cmp	w19, w2
	bgt	.L210
.L209:
	mov	x21, 0
	cbz	x7, .L213
	lsl	x26, x7, 2
	mov	x0, x26
.LEHB1:
	bl	_Znwm
.LEHE1:
	mov	x2, x26
	mov	x21, x0
	add	x27, x0, x26
	mov	w1, 0
	bl	memset
	cmp	w19, 0
	ble	.L214
	mov	x0, 0
	.p2align 3,,7
.L215:
	str	w0, [x21, x0, lsl 2]
	add	x0, x0, 1
	cmp	w19, w0
	bgt	.L215
.L214:
	asr	x0, x26, 2
	mov	w2, 63
	clz	x0, x0
	mov	x3, x20
	sub	w2, w2, w0
	mov	x1, x27
	mov	x0, x21
	sbfiz	x2, x2, 1, 32
	bl	_ZSt16__introsort_loopIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEElNS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_T1_
	cmp	x26, 64
	ble	.L216
	add	x26, x21, 64
	mov	x2, x20
	mov	x1, x26
	mov	x0, x21
	bl	_ZSt16__insertion_sortIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEENS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_
	cmp	x27, x26
	beq	.L213
	ldr	w4, [x20, 4]
	mov	x6, x26
	ldr	x3, [x20, 8]
.L222:
	mov	x1, x6
	ldr	w0, [x6, -4]
	mov	x5, x6
	ldr	w7, [x1], -4
	madd	w8, w0, w4, w0
	madd	w2, w7, w4, w7
	ldr	d0, [x3, w8, sxtw 3]
	ldr	d1, [x3, w2, sxtw 3]
	fcmpe	d0, d1
	bmi	.L221
	add	x6, x6, 4
	str	w7, [x5]
	cmp	x27, x6
	bne	.L222
.L213:
	ldp	x0, x1, [x25]
	stp	x0, xzr, [sp, 192]
	ldr	x0, [x22, 8]
	stp	xzr, xzr, [sp, 208]
	subs	x26, x0, x1
	beq	.L276
.L359:
	mov	x0, 9223372036854775800
	cmp	x26, x0
	bhi	.L356
	mov	x0, x26
.LEHB2:
	bl	_Znwm
.LEHE2:
	mov	x3, x0
	ldp	x1, x0, [x25, 8]
	sub	x27, x0, x1
.L224:
	add	x26, x3, x26
	stp	x3, x3, [sp, 200]
	str	x26, [sp, 216]
	cmp	x1, x0
	beq	.L226
	mov	x0, x3
	mov	x2, x27
	bl	memmove
	mov	x3, x0
.L226:
	mov	x26, x24
	add	x3, x3, x27
	ldr	x1, [x24, 8]
	str	x3, [sp, 208]
	ldr	x0, [x26], 8
	stp	x0, xzr, [sp, 224]
	stp	xzr, xzr, [sp, 240]
	ldr	x0, [x26, 8]
	subs	x27, x0, x1
	beq	.L277
	mov	x0, 9223372036854775800
	cmp	x27, x0
	bhi	.L357
	mov	x0, x27
.LEHB3:
	bl	_Znwm
.LEHE3:
	mov	x3, x0
	ldp	x1, x0, [x24, 8]
	sub	x28, x0, x1
.L227:
	add	x27, x3, x27
	stp	x3, x3, [sp, 232]
	str	x27, [sp, 248]
	cmp	x1, x0
	beq	.L229
	mov	x0, x3
	mov	x2, x28
	bl	memmove
	mov	x3, x0
.L229:
	ldp	w0, w1, [x20]
	str	w0, [sp, 256]
	add	x3, x3, x28
	str	x3, [sp, 240]
	str	w1, [sp, 260]
	mov	x2, 1152921504606846975
	mul	w0, w0, w1
	sxtw	x0, w0
	cmp	x0, x2
	bhi	.L358
	stp	xzr, xzr, [sp, 264]
	lsl	x28, x0, 3
	str	xzr, [sp, 280]
	cbz	x0, .L231
	mov	x0, x28
.LEHB4:
	bl	_Znwm
.LEHE4:
	add	x3, x0, x28
	str	x0, [sp, 264]
	str	x3, [sp, 280]
	mov	x27, x0
	cmp	x3, x0
	beq	.L232
	mov	x2, x28
	mov	w1, 0
	str	x3, [sp, 152]
	bl	memset
	ldr	x3, [sp, 152]
.L232:
	str	x3, [sp, 272]
	ldr	w13, [sp, 196]
	cmp	w19, 0
	ble	.L237
	ldrsw	x12, [sp, 260]
	mov	x9, x27
	ldrsw	x6, [sp, 228]
	sbfiz	x7, x13, 3, 32
	add	x12, x12, 1
	ldr	w15, [x20, 4]
	ldr	w4, [x24]
	mov	x8, 0
	ldr	w5, [x25]
	lsl	x12, x12, 3
	ldr	x14, [x20, 8]
	lsl	x6, x6, 3
	ldr	x11, [sp, 200]
	ldr	x10, [sp, 232]
	.p2align 3,,7
.L238:
	ldr	w0, [x21, x8, lsl 2]
	madd	w1, w0, w15, w0
	ldr	d0, [x14, w1, sxtw 3]
	str	d0, [x9]
	cmp	w5, 0
	ble	.L240
	ldr	x1, [x22]
	mov	x3, x11
	ldrsw	x16, [x25, 4]
	mov	w2, 0
	add	x1, x1, x0, sxtw 3
	lsl	x16, x16, 3
	.p2align 3,,7
.L239:
	ldr	d0, [x1]
	add	w2, w2, 1
	add	x1, x1, x16
	str	d0, [x3]
	add	x3, x3, x7
	cmp	w5, w2
	bne	.L239
.L240:
	cmp	w4, 0
	ble	.L242
	ldr	x16, [x26]
	mov	x2, x10
	ldrsw	x3, [x24, 4]
	mov	w1, 0
	add	x0, x16, x0, sxtw 3
	lsl	x3, x3, 3
	.p2align 3,,7
.L241:
	ldr	d0, [x0]
	add	w1, w1, 1
	add	x0, x0, x3
	str	d0, [x2]
	add	x2, x2, x6
	cmp	w1, w4
	bne	.L241
.L242:
	add	x8, x8, 1
	add	x9, x9, x12
	add	x10, x10, 8
	add	x11, x11, 8
	cmp	w19, w8
	bgt	.L238
.L237:
	ldr	w1, [sp, 192]
	mov	x0, x22
	stp	w1, w13, [x25]
	add	x1, sp, 200
.LEHB5:
	bl	_ZNSt6vectorIdSaIdEEaSERKS1_.isra.0
	ldr	x0, [sp, 224]
	str	x0, [x24]
	add	x1, sp, 232
	mov	x0, x26
	bl	_ZNSt6vectorIdSaIdEEaSERKS1_.isra.0
	mov	x0, x20
	add	x1, sp, 264
	ldr	x2, [sp, 256]
	str	x2, [x0], 8
	bl	_ZNSt6vectorIdSaIdEEaSERKS1_.isra.0
.LEHE5:
	ldr	x0, [sp, 264]
	cbz	x0, .L243
	bl	_ZdlPv
.L243:
	ldr	x0, [sp, 232]
	cbz	x0, .L244
	bl	_ZdlPv
.L244:
	ldr	x0, [sp, 200]
	cbz	x0, .L245
	bl	_ZdlPv
.L245:
	cbz	x21, .L300
	mov	x0, x21
	bl	_ZdlPv
.L300:
	mov	w0, w23
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldp	d8, d9, [sp, 96]
	.cfi_restore 73
	.cfi_restore 72
	ldp	x29, x30, [sp], 288
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L353:
	.cfi_def_cfa_offset 288
	.cfi_offset 19, -272
	.cfi_offset 20, -264
	.cfi_offset 21, -256
	.cfi_offset 22, -248
	.cfi_offset 23, -240
	.cfi_offset 24, -232
	.cfi_offset 25, -224
	.cfi_offset 26, -216
	.cfi_offset 27, -208
	.cfi_offset 28, -200
	.cfi_offset 29, -288
	.cfi_offset 30, -280
	.cfi_offset 72, -192
	.cfi_offset 73, -184
	.cfi_offset 74, -176
	.cfi_offset 75, -168
	.cfi_offset 76, -160
	.cfi_offset 77, -152
	mov	x4, 0
	mov	x5, 0
	b	.L176
.L272:
	movi	d1, #0
	fmov	d5, d9
	fmov	d0, 1.0e+0
	b	.L197
.L271:
	movi	d1, #0
	fmov	d0, 1.0e+0
	b	.L196
.L264:
	movi	d1, #0
	fmov	d5, d9
	fmov	d0, 1.0e+0
	b	.L163
.L208:
	.cfi_restore 74
	.cfi_restore 75
	.cfi_restore 76
	.cfi_restore 77
	fneg	d0, d0
	str	d0, [x3]
	cmp	w5, 0
	ble	.L211
	ldr	x0, [x22]
	mov	w1, 0
	ldrsw	x4, [x25, 4]
	add	x0, x0, x2, lsl 3
	lsl	x4, x4, 3
	.p2align 3,,7
.L212:
	ldr	d0, [x0]
	add	w1, w1, 1
	fneg	d0, d0
	str	d0, [x0]
	add	x0, x0, x4
	cmp	w5, w1
	bne	.L212
	b	.L211
.L216:
	mov	x1, x27
	mov	x0, x21
	mov	x2, x20
	bl	_ZSt16__insertion_sortIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEENS0_5__ops15_Iter_comp_iterIZN12_GLOBAL__N_1L25make_nonnegative_and_sortER6MatrixSB_SB_EUliiE_EEEvT_SE_T0_
	ldp	x0, x1, [x25]
	stp	x0, xzr, [sp, 192]
	ldr	x0, [x22, 8]
	stp	xzr, xzr, [sp, 208]
	subs	x26, x0, x1
	bne	.L359
.L276:
	mov	x27, 0
	mov	x3, 0
	b	.L224
	.p2align 2,,3
.L221:
	mov	x5, x1
	str	w0, [x1, 4]
	ldr	w0, [x1, -4]!
	madd	w2, w0, w4, w0
	ldr	d0, [x3, w2, sxtw 3]
	fcmpe	d0, d1
	bmi	.L221
	add	x6, x6, 4
	str	w7, [x5]
	cmp	x27, x6
	bne	.L222
	b	.L213
.L186:
	.cfi_offset 74, -176
	.cfi_offset 75, -168
	.cfi_offset 76, -160
	.cfi_offset 77, -152
	cbz	x27, .L260
	mov	x0, x27
	bl	_ZdlPv
.L260:
	fmov	d0, d8
	mov	x0, x20
	ldp	d10, d11, [sp, 112]
	.cfi_restore 75
	.cfi_restore 74
	mov	w23, 1
	ldp	d12, d13, [sp, 128]
	.cfi_restore 77
	.cfi_restore 76
	bl	_ZN12_GLOBAL__N_1L18cleanup_bidiagonalER6Matrixd
	ldr	w19, [x20, 4]
	cmp	w21, 0
	bgt	.L360
.L204:
	ldr	w5, [x20]
	sxtw	x7, w19
	cmp	w19, 0
	bgt	.L361
.L207:
	add	x22, x25, 8
	mov	x0, 2305843009213693951
	cmp	x7, x0
	bls	.L209
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	stp	d10, d11, [sp, 112]
	.cfi_remember_state
	.cfi_offset 75, -168
	.cfi_offset 74, -176
	stp	d12, d13, [sp, 128]
	.cfi_offset 77, -152
	.cfi_offset 76, -160
.LEHB6:
	bl	_ZSt20__throw_length_errorPKc
.LEHE6:
	.p2align 2,,3
.L277:
	.cfi_restore_state
	mov	x28, 0
	mov	x3, 0
	b	.L227
.L231:
	mov	x27, 0
	mov	x3, 0
	str	xzr, [sp, 264]
	str	xzr, [sp, 280]
	b	.L232
.L356:
.LEHB7:
	bl	_ZSt17__throw_bad_allocv
.LEHE7:
.L358:
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
.LEHB8:
	bl	_ZSt20__throw_length_errorPKc
.LEHE8:
.L357:
.LEHB9:
	bl	_ZSt17__throw_bad_allocv
.LEHE9:
	.p2align 2,,3
.L352:
	.cfi_offset 74, -176
	.cfi_offset 75, -168
	.cfi_offset 76, -160
	.cfi_offset 77, -152
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
.LEHB10:
	bl	_ZSt20__throw_length_errorPKc
.LEHE10:
.L174:
	mov	x0, 9223372036854775800
	b	.L175
.L282:
	.cfi_restore 74
	.cfi_restore 75
	.cfi_restore 76
	.cfi_restore 77
	mov	x19, x0
.L253:
	stp	d10, d11, [sp, 112]
	.cfi_offset 75, -168
	.cfi_offset 74, -176
	stp	d12, d13, [sp, 128]
	.cfi_offset 77, -152
	.cfi_offset 76, -160
	cbz	x21, .L344
	mov	x0, x21
	bl	_ZdlPv
.L344:
	mov	x0, x19
.LEHB11:
	bl	_Unwind_Resume
.LEHE11:
.L145:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 72
	.cfi_restore 73
	.cfi_restore 74
	.cfi_restore 75
	.cfi_restore 76
	.cfi_restore 77
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC1
	mov	x19, x0
	add	x1, x1, :lo12:.LC1
.LEHB12:
	bl	_ZNSt16invalid_argumentC1EPKc
.LEHE12:
.L341:
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -248
	.cfi_offset 21, -256
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -232
	.cfi_offset 23, -240
.L342:
	adrp	x2, _ZNSt16invalid_argumentD1Ev
	adrp	x1, _ZTISt16invalid_argument
	mov	x0, x19
	add	x2, x2, :lo12:_ZNSt16invalid_argumentD1Ev
	add	x1, x1, :lo12:_ZTISt16invalid_argument
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -200
	.cfi_offset 27, -208
	stp	d8, d9, [sp, 96]
	.cfi_offset 73, -184
	.cfi_offset 72, -192
	stp	d10, d11, [sp, 112]
	.cfi_offset 75, -168
	.cfi_offset 74, -176
	stp	d12, d13, [sp, 128]
	.cfi_offset 77, -152
	.cfi_offset 76, -160
.LEHB13:
	bl	__cxa_throw
.LEHE13:
.L279:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 72
	.cfi_restore 73
	.cfi_restore 74
	.cfi_restore 75
	.cfi_restore 76
	.cfi_restore 77
.L345:
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -248
	.cfi_offset 21, -256
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -232
	.cfi_offset 23, -240
.L343:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -200
	.cfi_offset 27, -208
	stp	d8, d9, [sp, 96]
	.cfi_offset 73, -184
	.cfi_offset 72, -192
	stp	d10, d11, [sp, 112]
	.cfi_offset 75, -168
	.cfi_offset 74, -176
	stp	d12, d13, [sp, 128]
	.cfi_offset 77, -152
	.cfi_offset 76, -160
	bl	__cxa_free_exception
	b	.L344
.L283:
	.cfi_restore 74
	.cfi_restore 75
	.cfi_restore 76
	.cfi_restore 77
	mov	x19, x0
	b	.L251
.L281:
	.cfi_offset 74, -176
	.cfi_offset 75, -168
	.cfi_offset 76, -160
	.cfi_offset 77, -152
	mov	x19, x0
	cbz	x27, .L344
	mov	x0, x27
	bl	_ZdlPv
	b	.L344
.L346:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 72
	.cfi_restore 73
	.cfi_restore 74
	.cfi_restore 75
	.cfi_restore 76
	.cfi_restore 77
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC0
	mov	x19, x0
	add	x1, x1, :lo12:.LC0
.LEHB14:
	bl	_ZNSt16invalid_argumentC1EPKc
.LEHE14:
	b	.L341
.L148:
	.cfi_offset 23, -240
	.cfi_offset 24, -232
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC2
	mov	x19, x0
	add	x1, x1, :lo12:.LC2
.LEHB15:
	bl	_ZNSt16invalid_argumentC1EPKc
.LEHE15:
	stp	x21, x22, [sp, 32]
	.cfi_remember_state
	.cfi_offset 22, -248
	.cfi_offset 21, -256
	b	.L342
.L280:
	.cfi_restore_state
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -248
	.cfi_offset 21, -256
	b	.L343
.L285:
	.cfi_offset 27, -208
	.cfi_offset 28, -200
	.cfi_offset 72, -192
	.cfi_offset 73, -184
	ldr	x1, [sp, 264]
	mov	x19, x0
	cbz	x1, .L249
	mov	x0, x1
	bl	_ZdlPv
.L249:
	ldr	x0, [sp, 232]
	cbz	x0, .L251
	bl	_ZdlPv
.L251:
	ldr	x0, [sp, 200]
	cbz	x0, .L253
	bl	_ZdlPv
	b	.L253
.L284:
	mov	x19, x0
	b	.L249
.L278:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 72
	.cfi_restore 73
	b	.L345
	.cfi_endproc
.LFE3775:
	.global	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA3775:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3775-.LLSDACSB3775
.LLSDACSB3775:
	.uleb128 .LEHB0-.LFB3775
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L281-.LFB3775
	.uleb128 0
	.uleb128 .LEHB1-.LFB3775
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB2-.LFB3775
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L282-.LFB3775
	.uleb128 0
	.uleb128 .LEHB3-.LFB3775
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L283-.LFB3775
	.uleb128 0
	.uleb128 .LEHB4-.LFB3775
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L284-.LFB3775
	.uleb128 0
	.uleb128 .LEHB5-.LFB3775
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L285-.LFB3775
	.uleb128 0
	.uleb128 .LEHB6-.LFB3775
	.uleb128 .LEHE6-.LEHB6
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB7-.LFB3775
	.uleb128 .LEHE7-.LEHB7
	.uleb128 .L282-.LFB3775
	.uleb128 0
	.uleb128 .LEHB8-.LFB3775
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L284-.LFB3775
	.uleb128 0
	.uleb128 .LEHB9-.LFB3775
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L283-.LFB3775
	.uleb128 0
	.uleb128 .LEHB10-.LFB3775
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L281-.LFB3775
	.uleb128 0
	.uleb128 .LEHB11-.LFB3775
	.uleb128 .LEHE11-.LEHB11
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB12-.LFB3775
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L279-.LFB3775
	.uleb128 0
	.uleb128 .LEHB13-.LFB3775
	.uleb128 .LEHE13-.LEHB13
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB14-.LFB3775
	.uleb128 .LEHE14-.LEHB14
	.uleb128 .L278-.LFB3775
	.uleb128 0
	.uleb128 .LEHB15-.LFB3775
	.uleb128 .LEHE15-.LEHB15
	.uleb128 .L280-.LFB3775
	.uleb128 0
.LLSDACSE3775:
	.text
	.size	_Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id, .-_Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.type	_GLOBAL__sub_I__Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id, %function
_GLOBAL__sub_I__Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id:
.LFB4570:
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
.LFE4570:
	.size	_GLOBAL__sub_I__Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id, .-_GLOBAL__sub_I__Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id
	.section	.init_array,"aw"
	.align	3
	.xword	_GLOBAL__sub_I__Z23gkh_svd_from_bidiagonalR6MatrixS0_S0_id
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
