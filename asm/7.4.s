; masm

assume cs:code,ds:data

data segment
db 'fUcK'
db 'YOU'
data ends

code segment

s:
mov ax,data
mov ds,ax
sub bx,bx
mov cx,4

a:
mov al,[bx]
and al,1011111b
mov [bx],al
inc bx
loop a

mov cx,3

b:
mov al,[bx]
or al,100000b
mov [bx],al
inc bx
loop b

mov ax,4c00h
int 21h
code ends

end s
