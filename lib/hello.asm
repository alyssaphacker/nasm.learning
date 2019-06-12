global _start

section .data
message: db 'aye sup dawg!', 10

section .text

_start:
	mov rdi, 65
	call print_char
	call print_newline
	
	mov rdi, message	; rdi <- arg for str_len
	call print_string
	mov rdi, 1234
	call print_uint
	call print_newline
	mov rdi, -1234
	call print_int
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

print_char:
	push rdi			; place arg to print on stack
	mov rsi, rsp		; pointer to the value on stack
	mov rdx, 1			; length to write
	mov rdi, 1			; file descriptor where to write
	mov rax, 1			; syscall write code
	syscall
	pop rdi
	ret

print_newline:
	mov rax, 1
	mov rdi, 1
	mov rdx, 1
	push 10
	mov rsi, rsp
	syscall
	pop rdi
	ret

print_uint:
	;handle initial zero! right now nothin would print

	mov rax, rdi		;place arg into diff register
	xor rbx, rbx		;count in rbx from zero
	mov rdi, 10			;need 10 in a register 
  .fillbuf:
	cmp rax, 0			;if rax is zero, 
	je .revprint			;jump to print
	xor rdx, rdx		;zero
	div rdi			; rax <- qoutient, rdx <- rem 
	add rdx, '0'		; transform digit to ASCII code
	push rdx			; ASCII digits stored in reverse
	inc rbx				
	jmp .fillbuf
  .revprint:
	cmp rbx, 0
	je .end
	dec rbx	
	mov rsi, rsp
	mov rdi, 1
	mov rdx, 1
	mov rax, 1
	syscall
	pop rax
	jmp .revprint

  .end:
	ret

print_int:
	cmp rdi, 0
	jg print_uint 
	push rdi
	mov rdi, '-'
	call print_char
	pop rdi	
	neg rdi
	call print_uint
	ret
