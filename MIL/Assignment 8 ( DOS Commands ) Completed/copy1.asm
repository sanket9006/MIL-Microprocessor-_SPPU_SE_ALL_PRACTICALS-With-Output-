
%macro  disp 2

mov rax,1

mov rdi, 1

mov rsi, %1

mov rdx, %2

syscall

%endmacro


%macro exit 0

mov rax, 60

mov rdi,0

syscall

%endmacro


section .data

buffer   db 20

buffer_length equ $-buffer



nwline db 10

m5 db 10,"syntax of command is incorrect"

l5 equ $-m5

m3  db   "Error in opening File",10
l3  equ   $-m3
m4  db   " 1 file copied",10
l4  equ   $-m4
m10  db   "wrong command",10
l10  equ   $-m10

section .bss

arr   resb 15
cnt   resq 1
fname resb 15

fname1 resb 15

fd_in resq 1

fd_in1 resq 1


section .text
global _start
_start:



mov rcx,00

pop rcx

mov [cnt],rcx

cmp rcx,3

je next_arg

disp m5,l5



jmp l0

next_arg:

        pop     rcx
        pop rcx
 
         
 
mov     rdx,00



up:     mov al,byte[rcx+rdx]

        mov byte[fname+rdx],al

cmp     byte [rcx+rdx],0        ;check for end of argument

        je   l88

        inc     rdx



        jmp     up



l88: mov byte[fname+rdx],0
     pop rcx
mov     rdx,00



up2:    mov al,byte[rcx+rdx]

        mov byte[fname1+rdx],al

cmp     byte [rcx+rdx],0        ;check for end of argument

        je      l85

        inc     rdx

        jmp     up2

l85:mov byte[fname1+rdx],0

 call copy_proc

jmp l0

wrong_command: disp m10,l10

l0: exit



copy_proc:


mov rax,2

        mov rdi,fname

        mov rsi,0

        mov rdx,0777o

        syscall



        mov [fd_in],rax



        mov rax,0

        mov rdi,[fd_in]

        mov rsi,buffer

        mov rdx,20

        syscall

        mov rax, 2            ; 'open' syscall

        mov rdi, fname1        ; file name

        mov rsi, 0102o      ; read and write mode, create if not

        mov rdx, 0666o       ; permissions set

        syscall



        mov [fd_in1], rax





        mov    rax, 1          ; 'write' syscall

        mov    rdi, [fd_in1]   ; file descriptor

        mov    rsi, buffer     ; message address

        mov    rdx, 20     ; message string length

        syscall





        mov rax,3

        mov rdi,[fd_in]

        syscall



        mov rax,3

        mov rdi,[fd_in1]

        syscall
disp m4,l4
ret


