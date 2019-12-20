TITLE Demonstrating low-level I/O Procedures  (Project06.asm)

; Author: Guleid Magan
; Course number/section: Project #4 Date: 12/09/19
; OSU: magang@oregonstate.edu
; Class Number: CS271-400
; Description: This program will introduce the program, ask for 10 decimal integers, validate input,
;place the numbers into an array and then display the list, sum and average value of those numbers.
;reference - https://stackoverflow.com/questions/29065108/masm-integer-to-string-using-std-and-stosb
;reference - https://stackoverflow.com/questions/13664778/converting-string-to-integer-in-masm-esi-difficulty


INCLUDE Irvine32.inc

MULTIPLIER = 10
MAXSIZE = 100000

displayString		MACRO buffer1
	push	edx
	mov		edx, OFFSET buffer1
	call	WriteString
	pop		edx
ENDM

mReadStr		MACRO varName, wordCount
	push	ecx
	push	edx
	mov		edx, OFFSET varName
	mov		ecx, (SIZEOF varName)-1
	call	ReadString
	mov		wordCount, eax
	pop		edx
	pop		ecx
ENDM

seq		MACRO	buffer, count
	

	push		esi
	push		ecx
	push		eax
	push		ax
	push		edx
	push		ebx

	mReadstr	buffer
	mov			esi, OFFSET buffer
	mov			edi, OFFSET count
	cld
	mov			edx , 0
	mov			eax, 0
	mov			ebx, 0
	mov			ecx, 5


counter:
	imul		edx, 10
	lodsb
	sub			al, 48d
	add			edx , eax
	call		WriteDec
	inc			ebx
	loop		counter

	mov			count, edx


	pop			ax
	pop			eax
	pop			esi
	pop			ecx
	pop			edx

	

	
	


endM






.data


request			DWORD ? ; range of numbers from user
wordCount		DWORD ?;

array			DWORD		10 DUP(?)

count			DWORD ?;
number			DWORD	10 DUP(0)
result			DWORD 10 DUP(?);
outString		db 16 DUP(0)
sum				DWORD ?;
intro_1			BYTE  "Demonstrating low-level I/O procedures", 0
intro_2			BYTE  "Written by: Guleid Magan"
intro_3			BYTE "Please provide 10 decimal integers", 0 
intro_4 		BYTE  "Each number needs to be small enough to fit inside a 32 bit register.", 0
intro_5 		BYTE  "After you have finished inputting the raw numbers I will display a list", 0
intro_6			BYTE  "of the integers, their sum, and their average value.", 0
prompt_2		BYTE  "Please enter an integer number: ", 0
space			BYTE  "   " , 0
sumString		db   16 DUP(0);
averageString	db	16 DUP(0);
unsorted		BYTE   "You entered the following numbers: ", 0
median			BYTE	"The sum of these numbers is: ", 0
average			BYTE	"The average is: ", 0
error_message	BYTE   "ERROR: You did not enter an integer number or your number was too big.", 0
Bye				BYTE  "Thanks for playing! ", 0

.code
main PROC


call	Introduction

displayString	intro_6

push		OFFSEt average
push		OFFSET sum
push		OFFSET array
push		OFFSET wordCount
push		 OFFSET count
push		OFFSET number
call		ReadVal

push		OFFSET outString
push		OFFSET array
call		WriteVal

push		OFFSET averageString
push		OFFSET sum
push		OFFSET average
push		OFFSET array
call		Calculate

call	goodbye


	exit	; exit to operating system
main ENDP

;Procedure that displays the introduction of the program to the user
;receives: nothing
;returns: displays several statements to the user
;preconditions: none
;registers changed: edx
Introduction	PROC

;displays the title 
	displayString	intro_1
	call		CrLf
	displayString	intro_2
	call		CrLf
	displayString	intro_3
	call		CrLf
	displayString	intro_4
	call		CrLf
	displayString	intro_5
	call		CrLf
	displayString	intro_6
	call		CrLf
	ret

	Introduction ENDP



;Procedure that validates that receives 10 numbers from the user. It then validates the input from user.
;It then converts the strings to numbers and loads them into the array.
;receives: wordCount as global variable
;returns: array of integers
;preconditions: none
;registers changed: edx, eax , esi, ebx , edi
ReadVal PROC


;getUserData
validateBlock:
;Get range of numbers
	push		ebp
	mov			ebp, esp
	mov			ecx, 10
	mov			edi, [ebp+20]
	mov			ebx, 0
	pushad
counterss:
	displayString	prompt_2
	mReadStr	number, wordCount
	push		ecx
	mov			esi, [ebp+8]
	mov			ecx, [ebp+16]
	mov			ecx, [ecx]
	
	cld
	xor			edx, edx
	xor			eax, eax

counter1:
;Zeroes out eax and then loads the next byte into al
	xor			eax, eax
	lodsb
;Validates the byte to ensure its a numeric value
	cmp			al, 48
	jb			Errors
	cmp			al, 57
	ja			Errors
	imul		edx, 10
	sub			eax, 48d
	add			edx, eax
	jc			Errors

next:
	loop		counter1
	jmp			others

Errors:
	pop			ecx
	displayString	OFFSET error_message
	call		CrLf
	jmp			counterss

others:
;Moves the integer into the array
	mov			eax, edx
	mov			[edi], edx
	add			ebx, edx
	stosd
;Moves to the next value of the array and zeroes out register to loop
	add			esi, 4
	pop			ecx
	xor			eax, eax
	loop		counterss

	popad
	pop			ebp


	ret			16

ReadVal ENDP

;Procedure that loops through each item in an array of integers. It then converts each integer to a string ,
;stores it in an output string variable, displays the integer and then moves to the next element in the array
;receives: an array of integers
;returns: array of strings
;preconditions: none
;registers changed: edx, eax , esi, ebx , edi
writeVal PROC
     push      ebp                 
     mov       ebp,esp
	 mov		esi, [ebp+8]
     mov       edi,[ebp + 12]       
     mov       ecx,10  
	 pushad
	 displayString	unsorted
	 call		CrLf
     process:
          push      ecx
          mov       eax,[esi]
          mov       ecx,10
          mov       ebx, 0              ;Clear register so we can use it to see each individual digit

          convertInt:
				;Sets edx to zero and divides eax by 10
               mov		edx, 0     
               div       ecx            
               push      edx             
               inc       ebx 
			   ;Checks if the end of the digit has been reached
               cmp      eax, 0       
               jne       convertInt    
               mov       ecx,ebx              
         
         convertDigits:       
		 ;It will convert all of the digits
               pop       eax                  
               add       eax, 48d
               stosb
               loop convertDigits
	
					
	;Pops register to use again, zeros out registers and moves to the next element
     pop       ecx           
     mov       ebx, 0         
     mov       edx, 0
     add       esi,4        
     loop      process
     displayString OFFSET outString
	 call		CrLf	
	 popad
     pop ebp

     ret 8
writeVal       ENDP


;Procedure that validates that receives an array. It then calculates the sum and average of the array,
;convert the numbers to strings and displays them
;receives: an array
;returns: sum and average of array
;preconditions: none
;registers changed: edx, eax , esi, ebx , edi
Calculate   PROC
      push   ebp
      mov      ebp, esp
      mov      esi, [ebp + 8]
	  mov		edi, [ebp+20]
	 pushad

      call           CrLf
      mov      ecx, 10
      mov      eax, 0
	  displayString		median
	  call			CrLf

   CalcSum:
   ;Accumulates the sum and saves the number
      add      eax, [esi]         
      add      esi, 4
      loop   CalcSum

	  call		WriteDec
	  call		CrLf
	  displayString	average
	  call		CrLf
	mov      ebx, 10
      mov      edx, 0
      div      ebx               ;find the average

	  process:
          mov       ecx,10
          mov		ebx, 0             

          convertInt:
				;Sets edx to zero and divides eax by 10
               mov		edx, 0       
               div       ecx            
               push      edx             
               inc       ebx 
			   ;Checks if the end of the digit hs been reached
               cmp      eax, 0       
               jne       convertInt    
			  ;Tracks bytes of the input to loop
               mov       ecx,ebx             
         
         convertDigits:       
		 ;It will convert all of the digits
		 ;Restores the value of eax 
               pop       eax                  
               add       eax, 48d
               stosb
               
 
               loop convertDigits
			   displayString OFFSET averageString
			   call		CrLf	
	popad
      pop   ebp

      RET      12
Calculate   ENDP

goodbye PROC

;goodbye
;Displays unique message if no valid numbers are entered
;along with the farewell message
	call			CrLf
	displayString	 Bye

	
	ret

goodbye		ENDP

END main
