; masm
; vim:ft=asm

assume cs:code,ds:data

data segment
data ends

stack segment
stack ends

code segment

start:
	; H=dx, L=ax, cx is divisor
	mov ax,4240h
	mov dx,000fh
	mov cx,0ah
	
	call divdw

divdw:
	push ax

	; ax=H/N, dx=H%N
	mov ax,dx
	sub dx,dx
	div cx

	; so ax is the High of the result, save in bx
	mov bx,ax

	; (H%N*65536+L)/N
	pop ax
	div cx

	; save reminder in cx
	mov cx,dx
	;
	mov dx,bx
	
	ret
	
	mov ax,4c00h
	int 21h

code ends

end start
