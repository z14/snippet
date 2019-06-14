; masm

assume cs:code,ds:data

data segment
db '1. display      '
db '2. brows        '
db '3. replace      '
db '4. modify       '
data ends

stack segment
dw 0
stack ends

code segment

start:

mov ax,data
mov ds,ax

mov ax,stack
mov ss,ax
mov sp,16

sub bx,bx

mov cx,4
a:
push cx
mov si,3

mov cx,4
b:
mov al,[bx+si]
and al,11011111b
mov [bx+si],al
inc si
loop b

add bx,16

pop cx
loop a

mov ax,4c00h
int 21h
code ends

end start
