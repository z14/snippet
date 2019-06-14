; masm

assume cs:code,ds:data

data segment
	db 10 dup (0)
data ends

stack segment
	dw 8 (0)
stack ends

code segment

start:
	mov ax,12666
	mov bx,data
	mov ds,bx
	mov si,0

	mov bx,stack
	mov ss,bx
	mov sp,16

	call dtoc

	mov dh,8			; line number
	mov dl,3			; column number
	mov cl,2			; style

	call show_str

	mov ax,4c00h
	int 21h

dtoc:
	mov bx,10
go:
	sub dx,dx
	div bx				; result in ax, modul in dx
	add dx,30h
	push dx				; result is inverse, use push and pop to invert it

	mov cx,ax
	inc si
	jcxz go_end

	jmp go

go_end:
	mov cx,si
	sub si,si
f:
	pop dx
	mov [si],dl
	inc si
	loop f

	mov byte ptr [si],0			; append 0 to the string
	
	sub si,si
	ret

show_str:
	mov ax,0b800h
	mov es,ax

	; (dh - 1) * 0a0h + ( dl * 2 - 2)
	mov al,0a0h
	dec dh
	mul dh
	sub dh,dh
	add dl,dl
	sub dl,2
	add ax,dx

	mov di,ax

say:
	push cx

	sub cx,cx
	mov cl,[si]

	jcxz over

	mov es:[di],cl
	pop cx
	mov es:[di+1],cl

	add di,2
	inc si
	jmp say

over:
	pop cx
	ret

code ends

end start
