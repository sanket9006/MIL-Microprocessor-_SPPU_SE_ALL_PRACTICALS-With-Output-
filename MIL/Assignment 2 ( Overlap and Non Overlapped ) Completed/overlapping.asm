section .data
msg1 db 'Contents before transfer',10
msg1length equ $-msg1
msg2 db 'Contents after transfer',10
msg2length equ $-msg2
msg3 db '*****MENU******',10
     db '1]without string instruction',10
     db '2]with string instruction',10
     db '3]Exit',10
     db 'Enter choice :',10
msg3length equ $-msg3
msg4 db 'Wrong  choice',10
msg4length equ $-msg4
msg5 db '  ',10
msg5length equ $-msg5

msg6 db 'Source block contents are :  ',10
msg6length equ $-msg6

msg7 db ' Enter Position : ',10
msg7length equ $-msg7

msg8  db  ' wrong choice',10
msg8length   equ   $-msg8
source_block db 01,02,03,04,05,00,00,00,00
source_block1 db 01,02,03,04,05
cnt dq 05
pos dq 00

section .bss
dispbuff resb 2
choice resb 2
position resb 2


%macro disp 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro


%macro accept 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .text
global _start
_start:

disp msg1,msg1length
call show_block
menu:disp msg3,msg3length
accept choice,2
cmp byte[choice],31h
jne l1
disp msg7,msg7length
accept position,2
call conversion
call proc1 
jmp menu

l1: cmp byte[choice],32h
 jne l2
disp msg7,msg7length
accept position,2
call conversion
call proc2
jmp menu
l2: cmp byte[choice],33h
jne l3
jmp exit
l3: disp msg8,msg8length
exit: mov rax,60
mov rdi,0
syscall


show_block:

disp msg6,msg6length
mov rsi ,source_block
mov rcx,[cnt]
add rcx,[pos]
mov rsi,source_block
S1:mov bl,[rsi]
push rsi
call display_no
pop rsi
inc rsi
dec rcx
jnz S1
ret

display_no:
push rcx
push rsi
mov rcx,02
mov rdi,dispbuff
l55:rol bl,04
mov dl,bl
and dl,0fh
cmp dl,09h
jbe M3
add dl,07h
M3:add dl,30h
mov[rdi],dl
inc rdi
dec rcx
jnz l55
disp dispbuff,02
disp msg5,msg5length
pop rsi
pop rcx
ret

conversion:
push rsi
mov rsi,position
mov bl,[rsi]
cmp bl,'9'
jbe l44
sub bl,07h
l44:sub bl,30h
mov byte[pos],bl
dec byte[pos]
pop rsi
ret

proc1:
mov rcx,[cnt]
mov rsi,source_block+4
mov rdi,rsi
add rdi,[pos]
l66:mov bl,[rsi]
mov [rdi],bl
dec rdi
dec rsi
dec rcx
jnz l66
disp msg2,msg2length
call show_block
ret

proc2:
mov rcx,[cnt]
mov rsi,source_block+4
mov rdi,rsi
add rdi,[pos]
std
rep movsb
disp msg2,msg2length
call show_block
ret


