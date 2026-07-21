section .text
global _start
_start:
	jmp shellcode
	string: db "merhaba hafiz",0x0a
	strlen equ $ - string
	shellcode:
		xor rax,rax
		mov al,1
		xor rdi,rdi
		inc rdi
		lea rsi,[rel string]
		xor rdx,rdx
		mov dl,strlen
		syscall
		xor rax,rax
		mov al,60
		xor rdi,rdi
		syscall
