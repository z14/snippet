; masm

assume cs:code,ds:data

data segment
	dw 0,0
data ends

stack segment
stack ends


code segment

start:
	mov ax,data
	mov ds,ax
	mov bx,0
	jmp word ptr [bx+1]

	mov ax,4c00h
	int 21h
code ends

end start
