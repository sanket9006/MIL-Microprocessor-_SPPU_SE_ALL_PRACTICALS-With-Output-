section .data
array1 db 21h,25h,30h,0ffh,99h
array2 times 5 db 0
msg1 db 'Menu :',10
     db '1.without string instruction',10
     db '2.with string instruction',10
     db '3.exit',10
     db 'Enter Choice',10
m1l equ $-msg1
msg2 db 'contents before transfer :',10
m2l equ $-msg2
msg3 db 'contents After transfer :',10
m3l equ $-msg3
msg4 db ' '
m4l equ $-msg4
msg5 db 'source array is ',10
m5l equ $-msg5
msg6 db'destination array is',10
m6l equ $-msg6
msg7 db'',10
m7l equ $-msg7
section .bss
dispbuff resb 2
arr resb 2
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
disp msg2,m2l
call disp_block
l8:
disp msg7,m7l
disp msg1,m1l
accept arr,2
cmp byte[arr],31h
jne l6
call proc_1
jmp l8
l6:cmp byte[arr],32h
jne l7
call proc_2
jmp l8
l7:cmp byte[arr],33h
jne l8
mov rax,60
mov rdi,0
syscall
 proc_1:
push rcx
push rsi
push rdi
mov rcx,5
mov rsi,array1
mov rdi,array2
l9:mov bl,[rsi]
mov [rdi],bl
inc rsi
inc rdi
dec rcx
jnz l9
disp msg3,m3l
call disp_block
pop rdi
pop rsi
pop rcx
ret
 proc_2:
push rcx
push rsi
push rdi
mov rsi,array1
mov rdi,array2
mov rcx,5
cld
rep movsb
disp msg3,m3l
call disp_block
pop rdi
pop rsi
pop rcx
ret
  disp_block:
push rcx
push rsi
disp msg5,m5l
mov rsi,array1
mov rcx,5
l1:mov bl,[rsi]
call disp_no
inc rsi 
dec rcx
jnz l1
disp msg7,m7l
disp msg6,m6l
mov rsi,array2
mov rcx,5
l2:mov bl,[rsi]
call disp_no
inc rsi
dec rcx
jnz l2
pop rsi
pop rcx
ret
disp_no:
push rcx
push rsi
mov rcx,2
mov rdi,dispbuff
l5:rol bl,04
mov dl,bl
and dl,0fh
cmp dl,09h
jbe l4
add dl,07h
l4:add dl,30h
mov [rdi],dl
inc rdi
dec rcx
jnz l5
disp dispbuff ,2
disp msg4,m4l
pop rsi
pop rcx
ret
