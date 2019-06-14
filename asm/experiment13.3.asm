; masm

assume cs:code,ds:data

data segment
data ends

code segment
	s1: db 'fuck a','$'
	s2: db 'fuck b','$'
	s3: db 'fuck c','$'
	s4: db 'fuck d','$'
	s: dw offset s1,offset s2,offset s3,offset s4
	row: db 2,4,6,8

start:
	mov ax,cs
	mov ds,ax
	mov bx,offset s
	mov si,offset row
	mov cx,4
ok:
	mov bh,0
	mov dh,[si]
	mov dl,0
	mov ah,2
	int 10h

	mov dx,[bx]
	mov ah,9
	int 21h

	inc si
	add bx,2
	
	loop ok
	
	mov ax,4c00h
	int 21h

code ends

end start
