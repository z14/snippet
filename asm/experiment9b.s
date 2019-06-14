; masm
; line 12 start at 6e0h
; line 13 start at 780h
; line 14 start at 820h

assume cs:code,ds:data

data segment
	db 'welcome to masm!'
	db 2,24h,71h			; green, red on green, blue on white
data ends

stack segment
	db 0
stack ends

code segment

start:
	mov ax, data
	mov ds,ax
	
	mov ax,0b800h
	mov es,ax

	mov ax,stack
	mov ss,ax
	mov sp,2

	sub di,di
	sub dx,dx
	
	mov cx,390h						;(6e0h+40h)/2
	jmp space
s:
	mov si,16
	mov cx,3
say:
	push cx
	sub bx,bx
	mov cx,16
a:
	mov al,[bx]
	mov es:[di],al
	mov al,[si]
	mov es:[di+1],al
	inc bx
	add di,2
	loop a

	inc si

	mov cx,40h
b:
	mov word ptr es:[di],0020h
	add di,2
	loop b

	pop cx
	loop say

	mov dx,1						; pass jcxz

	mov cx,300h						; (6e0h-40h)/2-50, retain the bottom row
space:
	mov word ptr es:[di],0020h		; actually, 20 can be anyone due to 00 means both fg and bg are black
	add di,2
	loop space

	mov cx,dx						; pass jcxz
	jcxz s

	mov ax,4c00h
	int 21h

code ends

end start
