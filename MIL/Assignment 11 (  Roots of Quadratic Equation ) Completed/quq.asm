section .data    

    a     dq 1.0

    b     dq -6.0

    c     dq 9.0

    integer4     dw 4

    infmt db 10,"a = %f",10,"b = %f",10,"c = %f",10,0

    outfmt db 10,"Root 1 = %f",10,10,"Root 2 = %f",10,0



section .bss

    sqrtdelta     resq 1

    negb   	 resq 1

    root1   	 resq 1

    root2   	 resq 1



global main

extern printf


section .text

main:

    push rbp

    finit   		 ;Initialize 80387

    mov rdi,infmt

    movq xmm0,[a]

    movq xmm1,[b]

    movq xmm2,[c]

;    mov rax,3

    call printf  



    fld qword[b]   		 ;Load b

    fmul qword[b]   	 ;b square

    fld qword[a]   		 ;Load a

    fmul qword[c]   	 ;Calculate ac

    fimul word[integer4]    ;Calculate 4ac

    fsub   		 ;Delta (b_square - 4ac)
    fsqrt   		 ;Square root of delta

    fst qword[sqrtdelta]   	 ;Store in memory for future use

    fldz   		 ;Load zero

    fsub qword[b]   	 ;-b

    fst qword[negb]   	 ;Store -b in memory for future use

    fadd   		 ;-b + square root of delta

    fld qword[a]   		 ;Load a

    fadd qword[a]   	 ;Calcuate 2a

    fdiv   		 ;Divide [-b + square root of delta] / 2a

    fstp qword[root1]   	 ;Store root 1

    fld qword[negb]   	 ;Load -b

    fsub qword[sqrtdelta]    ; -b - sq. root of delta

    fld qword[a]   		 ;Load a

    fadd qword[a]   	 ;Calcuate 2a

    fdiv   		 ;Divide [-b + sq. root of delta]/2a

    fstp qword[root2]   	 ;Store root 2

    mov rdi,outfmt

    movq xmm0,[root1]

    movq xmm1,[root2]

;    mov rax,2

    call printf

    pop rbp

    mov rax,60

    mov rdi,0

    Syscall



