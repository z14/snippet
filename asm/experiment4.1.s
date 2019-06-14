; set 0~63 to 0:200~0:23f sequentially

mov cx,63
mov ax,0020h
mov ds,ax
s:
mov bx,cx
mov [bx],cl
loop s
mov [0],cl

; or
mov cx,64
mov ax,0020h
mov ds,ax
mov bx,0
s:
mov [bx],bl
inc bx
loop s
