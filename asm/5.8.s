; copy data in memory ffff:0~ffff:b to 0:200~0:20b

mov cx,12
mov bx,cx

mov ax,0020h
mov es,ax

mov ax,0ffffh
mov ds,ax

s:
sub bx,1
mov dl,[bx]			; mov dx,[bx] works too
mov [es:bx],dl		; nasm style
;mov es:[bx],dl		; masm style
loop s

