.code64
.extern puts
.extern printf
.data

.section .rodata
S0:
	.string "Finding IDT..."
S1:
	.string "IDT loaded to %p\n"
S2:
	.string "[%d] %x\n"
S3:
	.string "Max addressable byte: %x\n"
S4:
	.string "IDT base address: %p\n"
.text
.global main
.type main, @function
main:
	pushq %rbp
	movq %rsp,%rbp
	subq $24, %rsp

	movq $S0, %rdi
	call puts

	movq $10, %rdi
	call malloc
	sidt (%rax)
	movq %rax, -8(%rbp)

	movq -8(%rbp), %rsi
	movq $S1, %rdi
	xor %rax, %rax
	call printf

	movq -8(%rbp), %rdi
	call retSidt

	movq %rax, -16(%rbp)
	movq %rdx, -24(%rbp)

	movq $S3, %rdi
	xor %rax, %rax
	movq -16(%rbp), %rsi
	call printf

	movq $S4, %rdi
	xor %rax, %rax
	movq -24(%rbp), %rsi
	call printf

	movq -8(%rbp), %rax
	movq %rax, %rdi
	call free

	movq $0, %rax
	leave
	ret

#%rdi contains pointer to sidt shit
.type readSidt, @function
readSidt:
	pushq %rbp
	movq %rsp, %rbp

	movq $0, %r10
	movq %rdi, %r11
sidt_loop_start:

	xor %rax, %rax
	movq $S2, %rdi
	movq %r10,%rsi
	movq (%r11,%r10,4),%rdx
	call printf
	incq %r10
	cmpq $3,%r10
	jc sidt_loop_start

	xor %rax, %rax
	xor %rdx, %rdx
	leave
	ret

.type retSidt, @function
retSidt:
	pushq %rbp
	movq %rsp, %rbp
	xor %rax, %rax
	xor %rcx, %rcx

	movw (%rdi),%ax				# *(RDI) get first 2 bytes (bits 0-15) which is the length of the IDT structure
	movq $2, %rcx
	movq (%rdi,%rcx,),%rdx		# *(RDI+2) get the next 8-bytes which is a pointer to the base of the IDT (non-paged)

	leave
	ret
