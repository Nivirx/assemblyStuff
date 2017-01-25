.code64
.data
S0:
    .string "Hello, world!"
.text
.global main
.type main, @function
main:
        pushq %rbp
        movq %rsp, %rbp
        movq $S0, %rdi
        call puts
        leave
        ret
