section .data
msg1 db '',10
     db '*****MENU******',10
     db '1]HEX to BCD',10
     db '2]BCD to HEX',10
     db '3]Exit',10
     db 'Enter choice :',10
msg1length equ $-msg1

msg2 db 'Enter 4 bit HEX no. : ',10
msg2length equ $-msg2
msg3 db 'Equivalent BCD no. : ',10
msg3length equ $-msg3

msg4 db 'Enter 5 bit BCD no. :',10
msg4length equ $-msg4
msg5 db 'Equivalent HEX no. : ',10
msg5length equ $-msg5

msg6 db 'Invalid Choice..!',10
msg6length equ $-msg6
msg7 db ' ',10
msg7length equ $-msg7
cnt db 00


section .bss

dispbuff resb 8 
choice resb 2
result resb 1
hex resb 5
bcd resb 6


%macro disp 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall 
%endm

%macro accept 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endm


section .text
global _start
_start:


menu:disp msg1,msg1length
accept choice,2

cmp byte[choice],'1'
jne L1
call proc1
jmp exit

L1:cmp byte[choice],'2'
jne L2   
call proc2
jmp exit

L2:cmp byte[choice],'3'
jne L3
jmp exit

L3:disp msg6,msg6length
jmp exit

exit:mov rax,60
mov rbx,0
syscall


proc1:
disp msg2,msg2length
accept hex,5
call conversion
mov rcx,0
mov ax,bx
mov bx,10
l11:mov dx,00
div bx
push rdx   ;dx=remainder
inc rcx
inc byte[cnt]
cmp ax,00   ;ax=quotient
jne l11
disp msg3,msg3length  ;equ bcd no.
l66: pop rdx
add dl,30h
mov [result],dl
disp result,1
dec byte[cnt]
jnz l66
disp msg7,msg7length
ret


proc2:
disp msg4,msg4length
accept bcd,6
disp msg5,msg5length
mov rsi,bcd
mov rcx,05
mov rax,0
mov ebx,0ah
l45:mov rdx,0
mul ebx
mov dl,[rsi]
sub dl,30h
add rax,rdx
inc rsi
dec rcx
jnz l45
mov ebx,eax
call disp_proc
disp msg7,msg7length
pp:
ret


disp_proc:
mov rcx,08
mov rdi,dispbuff
l3:rol ebx,4
mov dl,bl
and dl,0fh
add dl,30h
cmp dl,39h
jbe l2
add dl,07h
l2:
mov [rdi],dl
inc rdi
dec rcx
jnz l3
disp dispbuff+3,5
ppp:
ret



conversion:
    mov bx,0
    mov rcx,04
    mov rsi,hex
up1:
    rol bx,04
    mov al,[rsi]
    cmp al,39h
    jbe l22
    sub al,07h
l22:    sub al,30h
    add bl,al
    inc rsi
        dec rcx
        jnz up1
    ret
