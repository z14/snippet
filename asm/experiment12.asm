; masm
; vim:ft=asm

; todo

assume cs:code,ds:data

data segment
data ends

stack segment
stack ends

code segment
start:
	; copy interrupt routine to 0:200h
	mov ax,cs
	mov ds,ax
	mov si,offset s
	mov ax,0
	mov es,ax
	mov di,200h

	mov cx,offset f-offset s
	
	cld
	rep movsb

	; set int 0 point to 0:200h
	mov es,ax
	mov word ptr es:[0],200h
	mov word ptr es:[2],0

	mov ax,4c00h
	int 21h


	; our interrupt routine
s:
	jmp short s0
	db 'fuck you',0
s0:
	mov ax,data
	mov ds,ax
	mov si,202h

	mov ax,0b800h
	mov es,ax
	mov di,0f40h

	mov cl,[si]
	jcxz bye
	mov es:[di],cl
	mov byte ptr es:[di+1],04
	add di,2
	inc si
	loop s

bye:
	;iret						; iret or int 21h ?
	mov ax,4c00h
	int 21h
f:
	nop


code ends

end start

code ends

end start
