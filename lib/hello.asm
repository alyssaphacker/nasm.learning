global _start

section .data
message: db 'hello, naughty naughty!', 10

section .text

_start:
	
	mov rdi, message	; rdi <- arg for str_len
	call string_length	; rax <- return val
	mov rsi, rax		; rsi gets length (rdi still pts to msg)
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
	mov rdx, rsi
	mov rax, 1			; 'write' syscall numb
	mov rdi, 1			; stdout descriptor
	mov rsi, message	; string addr	
	syscall
	ret				

