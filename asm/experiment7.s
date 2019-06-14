; masm

assume cs:code,ds:data

data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'

	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
data ends

stack segment
stack ends

table segment
	db 21 dup ('year summ ne ?? ')
table ends

code segment

start:
	mov ax,data
	mov ds,ax

	mov ax,table
	mov ss,ax
	mov sp,344					; 336+4, for cx

	sub bx,bx
	sub bp,bp
	sub si,si

	;mov cx,14h
	mov cx,15h
s:
	push cx

	push si

	sub si,si
	sub di,di

	; year
	mov cx,2
a:
	mov ax,[bx+si]
	mov [bp+di],ax
	add si,2
	add di,2
	loop a

	mov byte ptr [bp+di],30h		; space
	inc di

	; income
	add si,80
	mov cx,2
b:
	mov ax,[bx+si]
	mov [bp+di],ax
	add si,2
	add di,2
	loop b

	mov byte ptr [bp+di],30h		; space
	inc di

	; personnel
	pop si
	mov ax,[168+si]
	mov [bp+di],ax
	add si,2
	add di,2

	mov byte ptr [bp+di],30h		; space
	inc di

	; income per
	mov ax,[bp+di-8]
	mov dx,[bp+di-6]
	div word ptr [bp+di-3]
	mov [bp+di],ax
	
	add di,2
	mov byte ptr [bp+di],30h		; space

	add bx,4
	add bp,16
	pop cx
	loop s

	mov ax,4c00h
	int 21h
code ends

end start
