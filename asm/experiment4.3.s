mov ax,07CFh		; debug on dosemu, IP default 100, CS default 07BF
mov ds,ax
mov ax,0020h
mov es,ax
mov bx,0
mov cx,17h
s:
mov al,[bx]
mov [es:bx],al
inc bx
loop s
