; multiply data in [ffff:0006] and 123

mov cx,123
mov ax,0ffffh
mov ds,ax
mov bx,6
mov al,[bx]
mov bx,115h	; 
sub ah,ah
sub dx,dx
add dx,ax	; should be in 0115h
sub cx,1
jmp bx		; here is the loop. Anyway, I don't know how to test additions, so the loop doesn't end
