; masm

assume cs:code,ds:data

data segment
	db 9,8,7,4,2,0
a	db 0,0,0,0,0,0
data ends

code segment

start:
	mov ax,0b800h
	mov es,ax
	mov ax,data
	mov ds,ax
	
	sub si,si
	mov bx,0
	mov cx,6
s:
	mov al,ds:[bx]
	out 70h,al
	in al,71h
	mov [a+si],al
	inc si
	inc bx
	loop s

	sub si,si
	sub di,di
	mov cx,6
s0:
	mov al,a[si]
	call p
	inc si
	loop s0

	mov ax,4c00h
	int 21h
	
	
p:
	push cx
	mov ah,al
	mov cl,4
	shr ah,cl
	and al,00001111b
	add ah,30h
	add al,30h
	mov es:[di],ah
	mov es:[di+2],al
	add di,4
	pop cx

	cmp si,2
	je space
	jb slash
	cmp si,4
	jna colon

	ret

slash:
	mov byte ptr es:[di],'/'
	add di,2
	ret
space:
	mov byte ptr es:[di],' '
	add di,2
	ret
colon:
	mov byte ptr es:[di],':'
	add di,2
	ret

code ends

end start
