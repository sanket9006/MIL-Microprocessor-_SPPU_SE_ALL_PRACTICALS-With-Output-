section .data
msg1          db    "Result of Factorial is.....   "
msg1length    equ    $-msg1 
result         dq    1 
msg2          db    " ",10
msg2length    equ   $-msg2  

%macro   disp    2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .bss
disp_buff    resb  16

section .text
global _start
_start:

pop rcx
pop rcx
pop rsi                         ;Here you will get the no of which you want to find factorial in rsi ( when you pop stack three time )

mov rax,0                       ;Making RAX contents zero ( RAX is 64 bits )
mov al,[rsi]                    ;taking contents pointed by rsi to Registar AL
cmp al,39h                      ;...1
jbe l3                          ;...2
sub al,07h                      ;...3   Here you can skip this three line's bcz if input is greater than 9 then result
                                ;will always wrong and this three instructions are for knowing whether no is greater than 9 or not 
                                ;if it is greater than 9 then subtract 37 else 30 , it is useless bcz input should only given from 1 to 9
l3:sub al,30h
mov rcx,rax                     ;taking contents of rax into rcx ( Taking factorial no )
call fact                       ;calling factorial procedure
disp msg1,msg1length            ;Displaying message " Result of Factorial is..... "
call disp_proc                  ;Calling disp_proc procedure for displaying output   

disp msg2,msg2length            ;Adding newline to the output 
mov rax,60                      ;EXIT system call
mov rdi,0                       ;EXIT system call
syscall                         ;EXIT system call


fact: 
push rcx                        ;PUSH contents of rcx on stack 
cmp rcx,1                       ;Fter pushing contents on stack , check whether it is equal to 1 or not if it is not equal to 
jne l5                          ;1 decreament it by 1 then again push that(decreamented no) element on stack and again check whether 
jmp l2                          ;it is equal to one or not do it until it gets equal to 1
l5:dec rcx                      
call fact
l2: pop rcx                     ;after getting 1 at the top pop that element at take it into rcx
mov rax,rcx                     ;take contents of rcx into rax for muktiplication
mul qword[result]               ;after taking it into the rax perform multiplication with [result[ which is quadword (64 bit)
mov qword[result],rax           ;after multiplication result is stored in rax , copy these result again into result  bcz we have to multiply it again
mov rbx,qword[result]           ;until 1 comes , then copy these result into rbx 
ret

disp_proc:
mov rsi,disp_buff	;point rsi to buffer
mov rcx,16		;load number of digits to display 

up1:

rol rbx,4		;rotate number left by four bits
mov dl,bl		;move lower byte in dl
and dl,0fh		;mask upper digit of byte in dl
add dl,30h		;add 30h to calculate ASCII code
cmp dl,39h		;compare with 39h
jbe skip1		;if less than 39h skip adding 07 more 
add dl,07h		;else add 07

skip1:
mov [rsi],dl		;store ASCII code in buffer
inc rsi			;point to next byte
loop up1		;decrement the count of digits to display
			;if not zero jump to repeat
disp disp_buff,16 	;display the number from buffer
ret
