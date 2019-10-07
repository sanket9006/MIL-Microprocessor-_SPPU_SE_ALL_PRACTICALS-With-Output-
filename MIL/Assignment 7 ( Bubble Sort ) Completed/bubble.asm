%include "macro.asm"

section .data

	nline        db    10

	nline_len    equ   $-nline



	mo         db    10,"Assgn 7: Bubble Sort using file operation "

	lo         equ   $-mo



	m1         db   10,"Enter filename of input data : "

	l1         equ   $-m1 



	m2         db     10,"Sorting using  Bubble Sort Operation successfully"

	           db     10,"Output Stored in same file ",10,10

	l2         equ    $-m2



	errmsg      db      10,"ERROR IN OPENING/READING/WRITING FILE... ",10

	errmsg_len  equ     $-errmsg



	ermsg        db     10,"ERROR IN WRITING FILE...",10

	ermsg_len    equ     $-ermsg



	exitmsg       db      10,10,"EXIT FROM PROGRAM...",10,10

	exitmsg_len   equ     $-exitmsg



section .bss

	buf         resb    1024

	buf_len      equ     $-buf

	filename    resb    50

	filehandle  resq     1

	abuf_len     resq    1

	array        resb    10

	n            resq    1

section .text 

global _start

_start:

	disp mo,lo

	disp m1,l1

	accept filename,50

	dec rax

	mov byte[filename+rax],0

	fopen filename

	cmp rax,-1H

	je Error

	mov [filehandle],rax

	fread [filehandle],buf,buf_len

	dec rax

	mov [abuf_len],rax 

 	call bsort

	jmp Exit

Error: disp  errmsg,errmsg_len

Exit:  disp  exitmsg,exitmsg_len 

       exit 

bsort:


	call buf_array

	xor rax,rax

	mov rbp,[n]

	dec rbp

	xor rcx,rcx

	xor rdx,rdx

	xor rsi,rsi

	xor rdi,rdi

	mov rcx,0

oloop:  mov rbx,0

	mov rsi,array

iloop:  mov rdi,rsi

	inc rdi

	mov al,[rsi]

	cmp al,[rdi]

	jbe next

	mov dl,0

	mov dl,[rdi]

	mov [rdi],al

	mov [rsi],dl

next:   inc rsi

	inc rbx

	cmp rbx,rbp

	jb iloop

	inc rcx

	cmp rcx,rbp

	jb oloop

	fwrite [filehandle],m2,l2

	fwrite [filehandle],array,[n]

	fclose [filehandle]

	disp m2,l2

	disp  array,[n]

	Ret

Error1:

	disp  ermsg,ermsg_len

ret

buf_array:

	xor rcx,rcx

	xor rsi,rsi

	xor rdi,rdi

	mov rcx,[abuf_len]

	mov rsi,buf

	mov rdi,array

next_num: 

	mov al,[rsi]

	mov [rdi],al

	inc rsi

	inc rsi

	inc rdi

	inc byte[n]

	dec rcx

	dec rcx

	jnz next_num

	ret


; OUTPUT OF PROGRAM
;[admin@ACA8FFD6 ~]$ nasm -f elf64 bubble.asm -o bubble.o
;[admin@ACA8FFD6 ~]$ ld -o bubble bubble.o
;[admin@ACA8FFD6 ~]$ ./bubble

;Assgn 7: Bubble Sort using file operation 
;Enter filename of input data : b.txt

;Sorting using  Bubble Sort Operation successfully
;Output Stored in same file 

;124689

;EXIT FROM PROGRAM...

