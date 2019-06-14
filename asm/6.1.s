; evaluate the sum of the 8 numbers

;global _start

section .data
data:
	dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h

section .text
;_start:
	sub ax,ax
	sub dx,dx
	mov bx,114h
	mov bx,data
	add bx,100h			; debug on dosemu default IP is 0100
	
	mov cx,8

s:
	add dx,[cs:bx]
	add bx,2
	loop s
