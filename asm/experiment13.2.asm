; masm

assume cs:code,ds:data

data segment
data ends

code segment

start:
	; load to mem
	mov ax,cs
	mov ds,ax
	mov si,offset go
	
	mov ax,0
	mov es,ax
	mov di,200h

	mov cx,offset goend-offset go

	rep movsb

	; set IVT
	mov word ptr es:[7ch*4],200h
	mov word ptr es:[7ch*4+2],0

	mov ax,4c00h
	int 21h

go:
	;cli
	push bp
	dec cx
	jcxz over
	mov bp,sp
	add [bp+2],bx				; push make sub sp,2
over:
	pop bp
	iret
goend:

code ends

end start
