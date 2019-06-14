; masm

assume cs:code,ds:data

data segment
db 'ibm             '
db 'dec             '
db 'dos             '
db 'vax             '
data ends

stack segment
dw 0
stack ends

code segment

s:
mov ax,data
mov ds,ax

add ax,stack
mov ss,ax
mov sp,16
;mov sp,2				; this works fine?

sub bx,bx

mov cx,4

a:
push cx
mov cx,3
mov si,0

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

end s
