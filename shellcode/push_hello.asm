section .text
global _start
_start:
	xor rbx,rbx
	mov rbx,0x00000a7a69666148
	push rbx              ; Son parça
	mov rbx,0x206162616872654d
	push rbx              ; İlk parça
	xor rax,rax
	mov al,1
	xor rdi,rdi
	mov dil,1
	mov rsi,rsp
	xor rdx,rdx
	mov dl,14
	syscall
	xor rax,rax
	mov al,60
	xor rdi,rdi
	syscall
