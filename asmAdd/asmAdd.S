.code64
.text
.global asmAdd
.type asmAdd, @function
asmAdd:
	pushq %rbp
	movq %rsp, %rbp
	addq %rsi, %rdi
	movq %rdi, %rax
	leave
	ret
