; fucking masm
; vim:ft=asm

assume cs:code,ds:data

data segment
data ends

stack segment
stack ends

code segment
start:
	mov ah,2			; move the cursor
	mov bh,0			; page 0
	mov dh,5			; row
	mov dl,12			; column
	int 10h

	mov ah,9			; print character on cursor
	mov al,'a'			; character
	mov bl,7			; color
	mov bh,0			; page 0
	mov cx,0			; repeat count
	int 10h

	mov ah,9			; print string on cursor
	; set ds:dx
	int 21h

	mov ax,4c00h		; return to DOS
	int 21h
code ends

end start

