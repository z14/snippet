; a greeting on boot
; need to be wrote to MBR

mov ax,0b800h			; start address of video memory
mov ds,ax
sub bx,bx

;mov cx,100

s:
mov byte [bx],'f'
mov byte [bx+1],4h
mov byte [bx+2],'u'
mov byte [bx+3],4h
mov byte [bx+4],'c'
mov byte [bx+5],4h
mov byte [bx+6],'k'
mov byte [bx+7],4h
mov byte [bx+8],' '
mov byte [bx+10],'y'
mov byte [bx+12],'o'
mov byte [bx+14],'u'
mov byte [bx+16],' '
;sub bx,18
;mov [18],bx
;loop s
jmp $

times 510-($-$$) db 0
db 55h,0aah
