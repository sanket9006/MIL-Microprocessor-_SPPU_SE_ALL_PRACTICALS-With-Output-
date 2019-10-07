;Ref: https://www.csee.umbc.edu/portal/help/nasm/sample_64.shtml
;https://stackoverflow.com/questions/38335212/calling-printf-in-x86-64-using-gnu-assembler

;Steps:
;$ nasm -f elf64 mpl10.asm
;$ gcc mpl10.o
;$ ./a.out

section .data
	welmsg db 10,"***WELCOME TO 80387, 64 BIT ALP TO CALCULATE MEAN, VARIANCE & STANDAR DEVIATION***",0
	arrmsg db 10,"Array Elements are: ",0
	meanmsg db 10,"CALCULATED MEAN IS:-",0
	sdmsg db 10,"CALCULATED STANDARD DEVIATION IS:-",0
	varmsg db 10,"CALCULATED VARIANCE IS:-",0

	fmt1 db "%s  ",10,0
	fmt2 db "%e",10,"%e",10,"%e",10,"%e",10,"%e",10, 0
	fmt3 db "%s  ","%e", 10, "%s  ","%e", 10, "%s  ","%e",10, 0

	array dq 102.56,198.21,100.67,230.78,67.93
	arraycnt dw 05

section .bss
	mean resq 1
	variance resq 1
	std_dev resq 1

section .text
	extern printf
   	global main
main:
	push rbp
	
	mov rdi,fmt1
	mov rsi,welmsg
	mov rax,0
	call printf

	mov rdi,fmt1
	mov rsi,arrmsg
	mov rax,0
	call printf

	mov rbx,array		;Base address of array loaded in RBX
	mov rsi,0		;index of element

	mov rdi,fmt2		;
	movq xmm0,[rbx+rsi*8]
	inc rsi
	movq xmm1,[rbx+rsi*8]
	inc rsi
	movq xmm2,[rbx+rsi*8]
	inc rsi
	movq xmm3,[rbx+rsi*8]
	inc rsi
	movq xmm4,[rbx+rsi*8]
	mov rax,5

	call printf

	finit
	fldz
	mov rbx,array
	mov rsi,00
	xor rcx,rcx
	mov cx,[arraycnt]
up:	fadd qword[RBX+RSI*8]
	inc rsi
	loop up

	fidiv word[arraycnt]
	fst qword[mean]

	MOV RCX,00
	MOV CX,[arraycnt]
	MOV RBX,array
	MOV RSI,00
	FLDZ
up1:	FLDZ
	FLD QWORD[RBX+RSI*8]
	FSUB QWORD[mean]
	FST ST1
	FMUL
	FADD
	INC RSI
	LOOP up1
	FIDIV word[arraycnt]
	FST QWORD[variance]
	FSQRT
	FST QWORD[std_dev]

	mov rdi,fmt3		;Displaying result
	mov rsi,meanmsg
	mov rdx,varmsg
	mov rcx,sdmsg
	movq xmm0,[mean]
	movq xmm1,[variance]
	movq xmm2,[std_dev]
	mov rax,3
	call printf

	pop rbp
	ret
