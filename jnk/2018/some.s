#cpuid.s Sample program to extract the processor vendor ID
# as -o cpuid cpuid.s
# ld -o cpuid cpuid.o
.section .data
output:
	.ascii "The processor Vendor ID is '        '\n"

.section .text
.globl _start
_start:
	mov $0, %eax
	cpuid	            #SYSCALL load regs w system info
    movl $output, %edi  #load output addr into edi
	movl %ebx, 28(%edi) #move first field 28 spaces into buf
	movl %edx, 32(%edi) #move second field 32 spaces into buf
	movl %ecx, 36(%edi) #move third field 36 space sinto buf
	movl $4, %eax       #syscall
	movl $1, %ebx		#file descriptor to write to
	movl $output, %ecx  #start of str to print
	movl $42, %edx      #len of str
	int $0x80           #call the service (print)
	movl $1, %eax       #1 -- exit func
	movl $0, %ebx       #return value of th eprogram 0 is good
	int $0x80           #call the service (terminate)
