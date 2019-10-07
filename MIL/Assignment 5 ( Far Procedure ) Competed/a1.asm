extern far_proc
					;   USING EXTERN DIRECTIVE]

global	filehandle, char, buf, abuf_len

%include	"macrofun.asm"

;------------------------------------------------------------------------
section .data

	msg1	        db 	10,10,10, 'Assignment 05:FAR PROCEDURE PROGRAM....' 
			
	msg1len 	equ	$-msg1

	filemsg	         db	10 ,"Enter filename	: "
	filemsg_len	equ      $-filemsg	
  
	charmsg	         db     10,"Enter character to search	: "
	charmsg_len	 equ	 $-charmsg

	errmsg	         db	10,"ERROR in opening File...",10
	errmsg_len	equ	$-errmsg

	exitmsg	         db	10,10,"Exit from program...",10,10
	exitmsg_len	 equ	$-exitmsg

;---------------------------------------------------------------------------
section .bss
	buf		resb	4096
	buf_len	        equ	$-buf		; buffer initial length

	filename	resb	50	
	char		resb	2	
 
	filehandle	resq	1
	abuf_len	resq	1		; actual buffer length

;--------------------------------------------------------------------------
section .text
	global _start
		
_start:
		disp	msg1,msg1len		;assignment name

		disp	filemsg,filemsg_len		
		accept 	filename,50
		dec	rax
		mov	byte[filename + rax],0	; blank char/null char

		disp	charmsg,charmsg_len		
		accept 	char,2
		
		fopen	filename		; on succes returns handle
		cmp	rax,-1H			; on failure returns -1
		jle	Error
		mov	[filehandle],rax	

		fread	[filehandle],buf, buf_len
		mov	[abuf_len],rax

		call	far_proc
		jmp	Exit

Error:	        disp	errmsg, errmsg_len

Exit:		disp	exitmsg,exitmsg_len
		exit
