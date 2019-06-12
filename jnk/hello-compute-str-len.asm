section .data
msg:
	db 'hello brave new world', 10

section .text
global _start

_start:
	mov rbx, msg
	mov rax, rbx	

counter:
	cmp byte [rax], 0
	jz	print
	inc rax
	jmp counter

print:
	sub rax, rbx
	mov rdx, rax 	;length
	mov rsi, msg	;string
	mov rdi, 1		;fd int
	mov rax, 1
	syscall

	mov rax, 60		;exit
	xor rdi, rdi
	syscall

