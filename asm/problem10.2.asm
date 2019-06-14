; masm
; change all letters to capitals

assume cs:code,ds:data

data segment
	db 'fuck you twice',0
	db 'fuck you twice',0
	db 'fuck you twice',0
	db 'fuck you twice',0
data ends

stack segment
	dw 8 dup (0)
stack ends

code segment

start:
	mov ax,data
	mov ds,ax

	mov ax,stack
	mov ss,ax
	mov sp,16

	sub si,si

	mov cx,4
go:
	call fuck0
	inc si
	loop go
	
	mov ax,4c00h
	int 21h

fuck0:
	push cx
fuck:
	sub cx,cx
	mov cl,[si]

	jcxz over

	and byte ptr [si],11011111b
	inc si
	loop fuck

over:
	pop cx
	ret

code ends

end start
