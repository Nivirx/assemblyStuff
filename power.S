.code64
.extern printf
.data
startMessage:
    .string "Power calculator in AMD64 ASM\n\n"
fmt:
    .string "pow(5,2)=%d and pow(3,2)=%d\n"
    
.text
.global main
main:
    pushq %rbp
    movq %rsp, %rbp
    
    movq $startMessage, %rdi
    xor %rax,%rax
    call printf                 #printf(message)

    movq $5, %rdi
	movq $2, %rsi
	call power	                # call power(5,2)
	push %rax	                # store return value on the stack

	movq $3, %rdi
	movq $3, %rsi
	call power	                # call power(3,2)
    
    movq $fmt,%rdi              # first argument of the c-string fmt
    xor %rax,%rax               # we have zero vector arguments
    popq %rsi                   # move pow(5,2) to rdx
    movq %rax,%rdx              # move return value from pow(3,2)
    call printf                 # printf(fmt,pow(5,2),pow(3,2))
        
	xor %eax,%eax               # return 0 for success
	leaveq
	ret

#PURPOSE: used to compute the value of a number raised to a power
#
#INPUT:	  %rdi - First argument - base number
#		  %rsi - Second argument - the power to raise it to
#
#OUTPUT: Will give the result as a return value (in rax)
#
#NOTES: power must be > 1
#
#VARIABLES:
#			%rdi - holds the base number
#			%rsi - holds the power
#			%rax is used for temporary storage and the return value
.type power, @function
power:
	pushq %rbp			    # function prolog
	movq %rsp, %rbp
	movq %rdi, %rax		    # copies base to rax so we can work with it

power_loop_start:
	cmpq $1, %rsi		    # if the power is 1, we are done
	je end_power

	imulq %rdi,%rax		    # multiply the base by the current value
	decq %rsi	            # power--

	jmp power_loop_start    # Run for the next power

end_power:
	leave		            # function epilog
	ret                     # return %rax
