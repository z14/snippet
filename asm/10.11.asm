; masm
; change all letters to capitals

assume cs:code,ds:data

data segment
	db 'fuck you twice!!'
data ends

stack segment
stack ends

code segment

start:
	mov ax,data
	mov ds,ax
	sub si,si
	mov cx,16

	call fuck

	mov ax,4c00h
	int 21h

fuck:
	and byte ptr [si],11011111b
	inc si
	loop fuck
	ret

code ends

end start
