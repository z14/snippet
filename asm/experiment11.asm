; masm
; vim:ft=asm

; todo

assume cs:code,ds:data

data segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

stack segment
stack ends

code segment
start:
	mov ax,data
	mov ds,ax
	mov si,0

	call letterc

	mov ax,4c00h
	int 21h

letterc:
	sub cx,cx
	mov cl,[si]

	jcxz bye

	cmp cl,61h
	jb pass
	cmp cl,7ah
	ja pass

	and cl,11011111b
	mov [si],cl
pass:
	inc si
	loop letterc

bye:
	ret


code ends

end start

code ends

end start
