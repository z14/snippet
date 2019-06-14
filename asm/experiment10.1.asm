; masm

assume cs:code,ds:data

data segment
	db 'fuck you twice!!',0
data ends

stack segment
stack ends

code segment

start:
	mov dh,8			; line number
	mov dl,3			; column number
	mov cl,2			; style
	mov ax,data
	mov ds,ax
	mov si,0

	call show_str

	mov ax,4c00h
	int 21h

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
