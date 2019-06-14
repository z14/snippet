; masm
; vim:ft=asm


assume cs:code,ds:data

data segment
data ends

stack segment
stack ends

code segment

start:
	mov ax,cs
	mov ds,ax
	mov ax,0
	mov es,ax

	; copy power2 to 0:200
	mov si,offset power2
	mov di,200h
	mov cx,power2end-power2
	; why is here a NOP after compile?
	cld
	rep movsb

	; 
	;mov di,07ch
	mov al,07ch
	mov ah,4
	mul ah
	mov di,ax
	mov word ptr es:[di],200h
	mov word ptr es:[di+2],0


	mov ax,4c00h
	int 21h

power2:
	push ax
	push dx

	mov dx,ax
	mul dx
	add ax,ax
	adc dx,dx

	pop dx
	pop ax
	iret
power2end:
	nop

code ends

end start
