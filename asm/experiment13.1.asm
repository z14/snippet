; masm

assume cs:code,ds:data

data segment
data ends

code segment

start:
	; load program to mem
	mov ax,cs
	mov ds,ax
	mov si,offset go

	mov ax,0
	mov es,ax
	mov di,200h

	mov cx,offset goend-offset go

	rep movsb

	; set IVT
	mov ax,0
	mov es,ax
	mov word ptr es:[7ch*4],200h
	mov word ptr es:[7ch*4+2],0

	mov ax,4c00h
	int 21h

go:
	mov bl,cl
	mov cx,1			; only print once
gos:
	mov ah,2
	int 10h
	inc dl				; the column should inc too

	mov ah,9
	mov al,[si]			; character
	cmp al,0
	je over
	inc si
	int 10h
	jmp gos
over:
	iret
goend:
	;nop

code ends

end start
