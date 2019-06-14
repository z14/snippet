; masm

assume cs:code,ds:data

data segment
	a db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
data ends

stack segment
stack ends

code segment

start:
	mov ax,data
	mov ds,ax

	mov ax,0b800h
	mov es,ax

	mov al,97
	sub ah,ah
	mov si,ax
	
	mov cl,4
	shr si,cl

	;call print
	mov bl,a[si]
	mov es:[160],bl
	mov byte ptr es:[161],4

	mov si,ax
	and si,00001111b

	;call print
	mov bl,a[si]
	mov es:[162],bl
	mov byte ptr es:[163],4

	mov ax,4c00h
	int 21h

print:
	mov bl,a[si]
	mov es:[160],bl
	mov byte ptr es:[161],4
	
	ret


code ends

end start
