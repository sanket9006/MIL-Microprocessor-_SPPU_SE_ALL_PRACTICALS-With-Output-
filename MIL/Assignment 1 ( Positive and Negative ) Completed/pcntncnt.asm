section .data


msg1 db '                            Program for displaying positive and  negative Number in assembly language',10
msg1length equ $-msg1

array db 8Fh,25h,23h,78h,5Ah

msg2 db ' ',10 
msg2length equ $-msg2 

newline db '',10
newlinelen equ $-newline

msg3 db 'Positive No in array are ',10
msg3length equ $-msg3

msg4 db 'Negative No in array are',10
msg4length equ $-msg4

ncnt db   0
pcnt db   0


section .bss

dispbuff resb 2
%macro disp 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro


section .text
global _start
_start:

 
mov rsi,array
mov rcx,05 
l3:mov bl,[rsi]
shl bl,01
jc l1
inc byte[pcnt]
jmp l2
l1:inc byte[ncnt]
l2:inc rsi
dec rcx
jnz l3


disp msg1,msg1length


disp msg3,msg3length
mov bl,byte[pcnt]
call disp_proc


disp msg4,msg4length
mov bl,byte[ncnt]
call disp_proc



mov rax,60
mov rdi,0
syscall


disp_proc:
push rcx
push rsi
mov rcx,02
mov rdi,dispbuff
l33:rol bl,04
mov dl,bl
and dl,0Fh
cmp dl,09h
jbe l22
add dl,07h

l22:add dl,30h
mov [rdi],dl
inc rdi
dec rcx
jnz l33

disp dispbuff,5
disp msg2,msg2length
pop rsi
pop rcx
ret




 
