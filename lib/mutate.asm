global _start

section .data
msg: db 'testing', 0
section .text
_start:
	mov rdi, msg 
	mov byte [rdi], 97
	call print_string
	jmp exit

exit:
	mov rax, 60			; 'exit' syscall num
	xor rdi, rdi		; zero rdi
	syscall	
	ret

string_length:
	xor rax, rax		; len in rax after proc
 .loop:
	inc rax
	cmp byte [rdi+rax], 0
	jnz .loop
	ret

print_string:
	call string_length
	mov rdx, rax		; length arg moved for syscall		
	mov rsi, rdi		; string ptr moved for syscall
	mov rax, 1			; 'write' syscall numb
	mov rdi, 1			; stdout descriptor
	syscall
	ret				


