; masm

assume cs:code,ds:d0

d0 segment
	db 1,2,3,4				;01 02 03 04
d0 ends
d1 segment
	dw 1,2,3,4				;01 00 02 00 03 00 04 00
d1 ends
d2 segment
	dd 1,2,3,4				;01 00 00 00 02 00 00 00 03 00 00 00 04 00 00 00
d2 ends
d3 segment
	db '1','2','3','4'		;31 32 33 34
d3 ends
d4 segment
	dw '1','2','3','4'		;31 00 32 00 33 00 34 00
d4 ends
d5 segment
	dd '1','2','3','4'		;31 00 00 00 32 00 00 00 33 00 00 00 34 00 00 00
d5 ends
d6 segment
	db '1234'				;31 32 33 34
d6 ends
d7 segment
	db '12','34'			;31 32 33 34
d7 ends
d8 segment
	dw '12','34'			;32 31 34 33
d8 ends
d9 segment
	;dw '123'				;syntax error
d9 ends
d10 segment
	dd '12','34'			;32 31 00 00 34 33 00 00
d10 ends
d11 segment
	;dd '123'				;syntax error
	;dd '1234'				;syntax error
d11 ends

code segment

start:
	mov ax,4c00h
	int 21h
code ends

end start
