; masm

assume cs:code,ds:data

data segment
	a dw f0,f1,f2,f3
data ends

stack segment
stack ends

code segment

start:
	mov ax,data
	mov ds,ax

	mov ax,0104h
	
	cmp ah,3
	ja over

	add ah,ah
	sub bx,bx
	mov bl,ah
	call a[bx]

over:
	mov ax,4c00h
	int 21h

f0:
	mov ax,0b800h
	mov es,ax
	mov si,0

	mov cx,2000
f0s:
	mov byte ptr es:[si],0020h
	add si,2
	loop f0s
	ret

f1:
	push ax
	mov ax,0b800h
	mov es,ax
	mov si,1

	pop ax
	mov cx,2000
f1s:
	mov ah,es:[si]
	and ah,11110000b
	add ah,al
	mov es:[si],ah
	add si,2
	loop f1s
	ret
	
f2:
	push ax
	mov ax,0b800h
	mov es,ax
	mov si,1

	pop ax
	mov cl,4
	shl al,cl

	mov cx,2000
f2s:
	mov ah,es:[si]
	and ah,00001111b
	add ah,al
	mov es:[si],ah
	add si,2
	loop f2s
	ret

f3:
	mov ax,0b800h
	mov ds,ax
	mov es,ax
	mov si,160
	mov di,0

	mov cx,2000
	rep movsw
	ret

code ends

end start
