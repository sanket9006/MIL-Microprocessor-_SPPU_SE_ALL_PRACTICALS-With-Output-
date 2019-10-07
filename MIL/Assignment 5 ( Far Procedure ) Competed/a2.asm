section .data



	smsg		db	10,"No. of spaces are	: "



	smsg_len:	equ	$-smsg



	



	nmsg		db	10,"No. of lines are	: "



	nmsg_len:	equ	$-nmsg







	cmsg		db	10,"No. of character occurances are	: "



	cmsg_len:	equ	$-cmsg







;---------------------------------------------------------------------



section .bss







	scount	resq	1



	ncount	resq	1



	ccount	resq	1



        disp_buff    resb 16



	;char_ans	resb	16







;---------------------------------------------------------------------



global	far_proc		







extern	filehandle, char, buf, abuf_len

; The directive EXTERN informs the assembler that the names, procedures and labels

; declared after this directive have already been defined in some other assembly language module.







%include	"macrofun.asm"



;---------------------------------------------------------------------



section .text



	global	_main



_main:







far_proc:          		;FAR Procedure



	



		xor	rax,rax



		xor	rbx,rbx



		xor	rcx,rcx



		xor	rsi,rsi	







		mov	bl,[char]



		mov	rsi,buf



		mov	rcx,[abuf_len]







again:	mov	al,[rsi]







case_s:	        cmp	al,20h		;space : 32 (20H)



		jne	case_n



		inc	qword[scount]



		jmp	next







case_n: 	cmp	al,0Ah		;newline : 10(0AH)



		jne	case_c



		inc	qword[ncount]



		jmp	next







case_c:	        cmp	al,bl			;character



		jne	next



		inc	qword[ccount]







next:		inc	rsi



		dec	rcx			;



		jnz	again			;loop again







		disp    smsg,smsg_len



		mov	rbx,[scount]



		call	disp_proc



	



		disp    nmsg,nmsg_len



		mov	rbx,[ncount]



		call	disp_proc







		disp    cmsg,cmsg_len



		mov	rbx,[ccount]



		call	disp_proc







        	fclose	[filehandle]



	ret







;------------------------------------------------------------------





disp_proc:



       mov rsi,disp_buff

       mov rcx,16

up:    ROL rbx,4

       mov dl,bl

       and dl,0fh

       cmp dl,09h

       jbe l23

       add dl,07h

l23:   add dl,30h

       mov [rsi],dl   

       inc rsi

dec rcx

jnz up

disp disp_buff+12,4

ret






