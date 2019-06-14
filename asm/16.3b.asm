; masm

assume cs:code,ds:data

data segment
	a dw c0,c30,c60,c90,c120,c150,c180
	c0 db '0',0
	c30 db '0.5',0
	c60 db '0.866',0
	c90 db '1',0
	c120 db '0.866',0
	c150 db '0.5',0
	c180 db '0',0
data ends

stack segment
stack ends

code segment

start:
	mov ax,data
	mov ds,ax

	mov ax,0b800h
	mov es,ax

	mov di,160
	
	; ax for argument
	mov ax,120

	sub bx,bx
	mov bl,30
	
	div bl
	sub ah,ah
	add al,al

	mov si,ax
	mov si,a[si]

s:
	mov cl,[si]
	jcxz over
	mov es:[di],cl
	mov byte ptr es:[di+1],4
	inc si
	add di,2
	loop s

over:
	mov ax,4c00h
	int 21h
	
code ends

end start
