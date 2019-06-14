; masm

assume cs:code,ds:data

data segment
data ends

code segment

start:
	mov ax,0b800h
	mov es,ax

	sub ah,ah
	mov al,8
	out 70h,al
	in al,71h

	mov al,01010100b

	mov ah,al
	mov cl,4
	shr ah,cl
	and al,00001111b
	add ah,30h
	add al,30h

	mov byte ptr es:[160],ah
	mov byte ptr es:[160+2],al

	mov ax,4c00h
	int 21h

	

code ends

end start
