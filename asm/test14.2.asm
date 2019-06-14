; masm

assume cs:code,ds:data

data segment
	db 0,0,0,0
data ends

code segment

start:
	mov ax,0b800h
	mov es,ax
	mov ax,data
	mov ds,ax

	mov ax,8
	mov dx,ax
	shl ax,1
	mov cl,3
	shl dx,cl
	add ax,dx

	mov dl,10
	sub si,si
g:
	div dl
	mov ds:[si],ah
	sub ah,ah
	inc si
	cmp al,0
	je go
	jmp g

go:
	sub di,di
	mov cx,si
p:
	mov al,ds:[si-1]
	add al,30h
	mov es:[di],al
	dec si
	add di,2
	loop p
	
	mov ax,4c00h
	int 21h

	

code ends

end start
