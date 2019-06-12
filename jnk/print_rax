section .data
codes:
	db	'0123456789ABCDEF'

section .text
global _start
_start:
	; number 1122... in hex
	mov rax, 0x1122334455667788

	mov rdi, 1
	mov rdx, 1
	mov rcx, 64
	;Each 4 bits should output as one hex digit
	;Use shift and bitwise AND to isolate
	;The result is the offset in 'codes' array
.loop:
	push rax
	sub tcx, 4
	; cl is subset of rcx
	; rax -- eax -- ax -- ah + al
	; rcx -- ecx -- cx -- ch + cl
	sar rax, cl
	and rax, 0xf

	lea rsi, [codes + rax]
	mov rax, 1

	; syscall leaves rxc and r11 changed
	push rcx
	syscall
	pop rcx

	pop rax
	; test can be used for the fastest 'is it zero' check
	; see docs for 'test' cmd
	test rcx, rcx
	jnz .loop

	mov rax, 60	; invoke 'exit' syscall
	xor rdi, rdi
	syscall
	
