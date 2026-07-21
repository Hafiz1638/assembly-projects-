section .text
global _start
_start:
	jmp one
	shellcode:
		pop rsi
		xor rax,rax
		mov al,1
		xor rdi,rdi
		mov dil,1
		xor rdx,rdx
		mov dl,msg_len
		syscall
		xor rax,rax
		mov al,60
		xor rdi,rdi
		syscall
	one:
	call shellcode
	string: db "hello world",0xa
	msg_len equ $ - string
