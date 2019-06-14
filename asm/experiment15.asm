; masm
; todo: if only A,enter is pressed, int9 won't work anymore, why?

assume cs:code,ds:data

data segment
data ends

code segment

start:
	; save original int9 address
	mov ax,cs
	mov ds,ax
	mov ax,0
	mov es,ax
	mov ax,es:[9*4]
	mov bx,offset newint9
	mov ds:[bx],ax
	mov ax,es:[9*4+2]
	mov ds:[bx+2],ax


	; load newint9 to 0:200h
	mov si,offset newint9
	mov di,200h
	mov cx,offset newend-offset newint9
	rep movsb

	cli
	; set ivt
	mov word ptr es:[9*4],204h
	mov word ptr es:[9*4+2],0
	sti

	mov ax,4c00h
	int 21h

newint9:
	dw 0,0
newstart:
	push ax
	push cx
	;push es
	push bx						; we have to push bx, or dosemu will exit when A is pressed, why?

	; call original int9
	pushf
	;call dword ptr ds:[0]
	call dword ptr cs:[200h]

	in al,60h
	cmp al,9eh
	jne newret
	mov ax,0b800h
	mov es,ax
	mov bx,0
	mov cx,2000
s:
	mov byte ptr es:[bx],41h
	add bx,2
	loop s
newret:
	pop bx
	;pop es
	pop cx
	pop ax
	iret
newend:

code ends

end start
