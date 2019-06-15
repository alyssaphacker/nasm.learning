global _start

section .data
message: db 'aye sup dawg!', 10
block: db 'xxxxxxxxxx', 0
section .text

_start:
	mov rdi, block
	call print_string
	mov rdi, block ;buf addr 
	mov rsi, 10	;len
	call read_word
	mov rdi, block
	call print_string
	call print_newline
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
	call print_newline
	call read_char
	mov rdi, rax
	call print_char
	call print_newline
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

read_char:
	push rdi
	; no args, returns char in rax
	push rax	;just make a spot in stack so i can read into the addr location
	mov rsi, rsp	;the ptr to the place on the stack is arg to syscall read
	mov rdi, 0	; stdin 
	mov rax, 0	; syscall num for read
	mov rdx, 1 	; length
	syscall
	pop rax
	pop rdi
	ret

 
read_word:	;takes buf addr in rdi, size in rsi  
  	push rdi	;going to use this reg but need bufbase to pop rax for ret
  	dec rsi	;length -1
  
  .leadingwhite:
	call read_char
	cmp rax, 9 
	je .leadingwhite
	cmp rax, 10
	je .leadingwhite
	cmp rax, 32
	je .leadingwhite

  .nonwhite:
	mov byte [rdi], al
	inc rdi 
	dec rsi	

	call read_char
	cmp rax, 9
	je .retbuf
	cmp rax, 10
	je .retbuf
	cmp rax, 32
	je .retbuf

	cmp rsi, 0
	jne .nonwhite

 
	xor rax, rax
	ret
  .retbuf:
	mov byte[rdi], 0 ;attach nullbyte
	pop rax
	ret		
	




