; masm
; vim:ft=asm


assume cs:code,ds:data

data segment
	a dw 1,2,3,4,5,6,7,0fff0h
	b dd 0
data ends

stack segment
stack ends

code segment

start:
	mov ax,data
	mov ds,ax

	sub si,si
	sub ax,ax
	mov cx,8
s:
	mov ax,a[si]
	add word ptr b,ax
	adc word ptr [b+2],0
	add si,2
	loop s

	mov ax,4c00h
	int 21h

code ends

end start

code ends

end start
