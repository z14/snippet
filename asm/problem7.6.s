; masm

assume cs:code,ds:data

data segment
db '1. file         '
db '2. edit         '
db '3. search       '
db '4. view         '
db '5. options      '
db '6. help         '
data ends

code segment

s:
mov ax,data
mov ds,ax

sub bx,bx

mov si,3

mov cx,6

a:
mov al,[bx+si]
and al,11011111b
mov [bx+si],al
add bx,16

loop a

mov ax,4c00h
int 21h
code ends

end s
