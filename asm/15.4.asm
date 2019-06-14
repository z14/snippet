; masm

assume cs:code,ds:data

data segment
	dw 0,0
data ends

code segment

start:
	; save the original int9 address
	mov ax,0
	mov es,ax
	mov ax,data
	mov ds,ax
	mov ax,es:[9*4]
	mov ds:[0],ax
	mov ax,es:[9*4+2]
	mov ds:[2],ax
	

	cli
	; set ivt for new int9 address
	; we can use the address in this program, so we don't have to load newint9 code to elsewhere
	mov word ptr es:[9*4],offset newint9			; why debug on dosemu quits right here?
	mov word ptr es:[9*4+2],cs
	sti

	mov ax,0b800h
	mov es,ax
	mov bx,0
	mov al,'a'
a2z:
	mov es:[bx],al
	inc al

	call delay

	cmp al,'z'
	jna a2z

	; recover ivt for original int9 before exit
	mov ax,0
	mov es,ax
	mov ax,ds:[0]
	mov word ptr es:[9*4],ax
	mov ax,ds:[2]
	mov word ptr es:[9*4+2],ax

	mov ax,4c00h
	int 21h

delay:
	push dx
	push cx

	mov dx,2ffh
	mov cx,0
s:
	sub cx,1
	sbb dx,0
	cmp cx,0
	jne s
	cmp dx,0
	jne s

	pop cx
	pop dx
	ret

newint9:
	push ax
	push es

	; simulate original int9
	pushf

	;pushf
	;pop ax
	;and ah,11111100b
	;push ax
	;popf

	call dword ptr ds:[0]
	
	in al,60h
	cmp al,39h				; scanning code 39h is space
	jne newret
	mov ax,0b800h
	mov es,ax
	;mov byte ptr es:[1],4
	inc byte ptr es:[1]
newret:
	pop es
	pop ax
	iret

newint9end:

code ends

end start
