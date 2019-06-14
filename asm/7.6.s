; masm

assume cs:code,ds:data

data segment
db 'fuck'
db 'YOUU'
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

mov al,[bx+4]
or al,100000b
mov [bx+4],al

inc bx
loop a

mov ax,4c00h
int 21h
code ends

end s
