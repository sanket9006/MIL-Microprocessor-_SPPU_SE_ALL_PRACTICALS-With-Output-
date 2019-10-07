section .data


menu db " ",10
     db "Program for Hex Multiplication ",10,10
     db "1. Successive Addition ",10
     db "2. Add and Shift ",10,10
     db "Enter Your Choice ",10
menul equ $-menu

nl db " ",10,10
nll equ $-nl

resis db "Result is ",10
resisl equ $-resis

mulp db "Multiplier is ",10
mulpl equ $-mulp
muld db "Multiplicand is ",10
muldl equ $-muld

multi1 db 06
multi2 db 06


section .bss

choice resb 2

dispbuff resb 2
dispbufff resb 2

%macro accept 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

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


disp menu,menul
accept choice,2

cmp byte[choice],31h
jne l01
call procedure_1

l01:cmp byte[choice],32h
jne l02
call procedure_2


l02:
mov rax,60
mov rdi,0
syscall


procedure_2:
disp nl,nll 

disp mulp,mulpl
mov bl,[multi1]
call disp_no1
disp nl,nll

disp muld,muldl
mov bl,[multi2]
call disp_no1
disp nl,nll
call proc_2
disp nl,nll

ret


procedure_1:

disp nl,nll 

disp mulp,mulpl
mov bl,[multi1]
call disp_no1
disp nl,nll

disp muld,muldl
mov bl,[multi2]
call disp_no1
call proc_1

disp nl,nll

ret
	
proc_1:
	push rcx

	mov ax,0000h
	mov bx,0000h
	mov cx,0000h	
	
	mov bl,[multi1]
	mov bh,00

	mov cl,[multi2]
        mov ch,00



   l99:	add ax,bx
	dec cl
	jnz l99
	mov bx,ax
	disp nl,nll
	disp resis,resisl
	call disp_no2
        pop rcx
ret





disp_no1:
        push rcx
        push rdi
        push rsi
        mov rdi ,dispbuff
        mov rcx,02
l6:
        rol bl,04
        mov dl,bl
        and dl,0fh
        cmp dl,09h
        jbe l7
        add dl,07h
l7:
        add dl,30h
        mov [rdi],dl
        inc rdi
        dec rcx
        jnz l6
        disp dispbuff,2
        pop rsi
        pop rdi
        pop rcx
ret

proc_2:
mov bx,0000
mov cl,08
mov dh,00
mov dl,[multi1]
mov al,[multi2]

l65:shr al,01
jnc only_shift
add bx,dx
only_shift:
shl dx,01
dec cl
jnz l65
disp resis,resisl
call disp_no2

ret


disp_no2:
        push rcx
        push rdi
        push rsi
        mov rdi ,dispbufff
        mov rcx,04
l06:
        rol bx,04
        mov dl,bl
        and dl,0fh
        cmp dl,09h
        jbe l077
        add dl,07h

l077:
        add dl,30h
        mov [rdi],dl
        inc rdi
        dec rcx
        jnz l06
        disp dispbufff,4
       
        pop rsi
        pop rdi
        pop rcx
ret


