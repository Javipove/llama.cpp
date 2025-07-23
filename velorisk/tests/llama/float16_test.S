	.file	"float16_test.c"
	.option pic
	.text
	.align	1
	.align	4
	.globl	ggml_compute_fp16_to_fp32
	.type	ggml_compute_fp16_to_fp32, @function
ggml_compute_fp16_to_fp32:
	fcvt.s.h	fa0,fa0
	ret
	.size	ggml_compute_fp16_to_fp32, .-ggml_compute_fp16_to_fp32
	.ident	"GCC: (GNU) 10.4.0"
	.section	.note.GNU-stack,"",@progbits
