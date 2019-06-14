; masm

assume cs:code,ds:data

data segment
data ends

code segment

start:
	sub ax,ax
	int 16h

	mov bx,0b800h
	mov es,bx
	mov bx,1

	mov ah,1

	cmp al,'r'
	je r
	cmp al,'g'
	je g
	cmp al,'b'
	je b
	
	jmp sret

r:
	shl ah,1
g:
	shl ah,1
b:
	mov cx,2000
s:
	and byte ptr es:[bx],11111000b
	or es:[bx],ah
	add bx,2
	loop s

sret:
	mov ax,4c00h
	int 21h

code ends

end start
