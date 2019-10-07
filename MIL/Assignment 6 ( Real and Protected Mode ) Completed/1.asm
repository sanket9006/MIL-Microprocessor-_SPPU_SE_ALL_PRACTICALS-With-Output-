section .data
msg1 db 'processor is in protected mode',10
msg1length equ $-msg1
msg2 db 'processor is in real mode',10
msg2length equ $-msg2
msg3 db 'LDTR contents:',10
msg3length equ $-msg3
msg4 db 'GDTR contents:',10
msg4length equ $-msg4
msg6 db 'TR contents:',10
msg6length equ $-msg6
msg7 db 'MSW contents:',10
msg7length equ $-msg7
msg5 db '',10
msg5length equ $-msg5
msg8 db ':'
msg8length equ $-msg8
msg9 db 'IDTR contents:',10
msg9length equ $-msg9

section .bss
dispbuff1 resb 4
a resd 1         
  resw 1
b resw 1         
c resw 1         
d resd 1         
e resd 1          
  resw 1
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
smsw eax
mov [d],eax
ror eax,1
jc j1
disp msg2,msg2length
jmp exit
j1:disp msg1,msg1length
sgdt[a]
sldt[b]
str[c]
disp msg4,msg4length
mov bx,[a+4]
call disp16_proc
mov bx,[a+2]
call  disp16_proc
disp msg8,msg8length
mov bx,[a+0]
call disp16_proc

disp msg5,msg5length
disp msg9,msg9length
mov bx,[e+4]
call disp16_proc
mov bx,[e+2]
call  disp16_proc
disp msg8,msg8length
mov bx,[e+0]
call disp16_proc

disp msg5,msg5length
disp msg3,msg3length
mov bx,[b+0]
call disp16_proc

disp msg5,msg5length
disp msg6,msg6length
mov bx,[c+0]
call disp16_proc

disp msg5,msg5length
disp msg7,msg7length
mov bx,[d+2]
call disp16_proc
mov bx,[d+0]
call disp16_proc

exit:mov rax,60
mov rdi,0
syscall

disp16_proc:
push rcx
push rsi
mov rdi,dispbuff1
mov rcx,04
r3:rol bx,04
mov dl,bl
and dl,0Fh
cmp dl,09h
jbe r2
add dl,07h
r2:add dl,30h
mov [rdi],dl
inc rdi
dec rcx
jnz r3
disp dispbuff1,4
;disp msg5,msg5length
pop rsi
pop rcx
ret
