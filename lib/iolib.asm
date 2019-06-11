global _start			;I may remove this

section .data

section .text

exit:					; needed so prevent segfault!!
	mov rax, 60			; 'exit' syscall num
	xor rdi, rdi		; zero rdi
	syscall	
	ret	
