; masm

assume cs:code,ds:data

data segment
	db 'welcome to masm!'
data ends

stack segment
stack ends

code segment

start:
	mov ax, data
	mov ds,ax
	
	mov ax,0b800h
	mov es,ax

	sub bx,bx
	sub si,si
	sub di,di
	sub dx,dx
	
	mov cx,3e0h						;(780h+40h)/2
	jmp space

say:
	mov cx,8
a:	; 'welcome '
	mov al,[bx+si]
	mov es:[di],al
	mov byte ptr es:[di+1],2		; green
	inc si
	add di,2
	loop a

	mov cx,3
b:	; 'to'
	mov al,[bx+si]
	mov es:[di],al
	mov byte ptr es:[di+1],24h		; red on green
	inc si
	add di,2
	loop b

	mov byte ptr es:[di-1],0h		; remove background color of the space after 'to'

	mov cx,5
c:	; 'masm!'
	mov al,[bx+si]
	mov es:[di],al
	mov byte ptr es:[di+1],71h		; blue on white
	inc si
	add di,2
	loop c

	mov dx,1						; pass jcxz

	mov cx,390h						; (780h+40h)/2-50, retain the bottom row
space:
	mov word ptr es:[di],0020h		; actually, 20 can be anyone due to 00 means both foreground and background are black
	add di,2
	loop space

	mov cx,dx						; pass jcxz
	jcxz say

	mov ax,4c00h
	int 21h

code ends

end start
