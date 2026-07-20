	section .data
	yazi: db "metin:"
	boyut equ $ - yazi
	a_y: db "anahtar 0-9 arasi:"
	boyut_a equ $ - a_y
	section .bss
	a: resb  128
	anahtar: resb 4
	b : resb 128
	section .text
	global _start
	_start:
		mov rax,1
		mov rdi,1
		lea rsi,[a_y]
		mov rdx,boyut_a
		syscall
		mov rax,0
		mov rdi,0
		mov rsi,anahtar
		mov rdx,4
		syscall
		mov bl,[anahtar]
		sub bl,'0'
		mov rax,1
		mov rdi,1
		mov rsi,yazi
		mov rdx,boyut
		syscall
		mov rax,0
		mov rdi,0
		lea rsi,[a]
		mov rdx,128
		syscall
		dec rax
		mov rcx,rax
		mov r8,rax
		cld
		lea rsi,[a]
		lea rdi,[b]
	loop_xor:
		lodsb
		xor al,bl
		stosb
		loop loop_xor
		mov rax,1
		mov rdi,1
		lea  rsi,[b]
		mov rdx,r8
		syscall
		mov rax,60
		xor rdi,rdi
		syscall
