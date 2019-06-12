global _start

section .data
message: db 'hello, world!', 10

section .text
_start:
	mov rax, 1			; 'write' syscall numb
	mov rdi, 1			; stdout descriptor
	mov rsi, message	; string addr	
	mov rdx, 14			; string length
	syscall				
	
	;segfault without the next code
	;b/c didn't write any instructions so machine gets garbage	

	mov rax, 60			; 'exit' syscall num
	xor rdi, rdi		; zero rdi
	syscall	
