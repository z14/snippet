; add data in [ffff:0,b]

	mov cx,12
	mov ax,0ffffh
	mov ds,ax
	sub ax,ax
	sub dx,dx

	mov bx,cx

s:	sub bx,1
	mov ax,[bx]
	sub ah,ah
	add dx,ax
	loop s
