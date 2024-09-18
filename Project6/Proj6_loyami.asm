TITLE Designing low-level I/O procedures      (Proj6_loyami.asm)

; Author: Michelle Loya
; Last Modified: 2023
; OSU email address: loyami@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number: 6                Due Date: 3/19/2023
; Description: This program will collect user values and display their sum and average
;			   via low-level I/O procedures and macros

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------
; Name: mGetString
;
; Displays a prompt and moves user input into memory location.
;
; Receives: address of text, address of input location, size of input
; ---------------------------------------------------------------------------------
mGetString MACRO textOffset:REQ, userInputOffset:REQ, _inputSize:REQ
	PUSH	edx
	PUSH	ecx

  	mDisplayString textOffset		;displays text

	mov		edx, userInputOffset
	mov		ecx, _inputSize
	call	ReadString

	POP		ecx
	POP		edx
ENDM

; ---------------------------------------------------------------------------------
; Name: mDisplayString
;
; Prints a string which is stored in a specified memory location
;
; Receives: address of string
; ---------------------------------------------------------------------------------
mDisplayString MACRO _textOffset:REQ
	PUSH	edx

    MOV		edx, _textOffset
	call	WriteString				;displays text

	POP		edx
ENDM

;Global Constants:
INPUTSIZE = 10
MAX       = 2147483646  ;32-bit signed interger max

.data
programTitle	BYTE	"Designing low-level I/O procedures!",13,10,
						"by Michelle Loya",13,10,13,10,0
introText		BYTE	"Please provide 10 signed decimal integers. Each number needs to be small",13,10,
						"enough to fit inside a 32 bit register. After you have finished inputting",13,10,
						"the raw numbers, I will display a list of the integers, their sum, and their",13,10,
						"average value.",13,10,13,10,0
promptText		BYTE	"Enter an signed number: ",0
errorText		BYTE	"ERROR: Input does not meet requirements.",13,10,
						"Enter a corrected value: ",0
listText		BYTE	13,10,"List of numbers: ",13,10,0
sumText			BYTE	13,10,"Sum: ",0
averageText		BYTE	13,10,"Truncated average: ",0
goodbyeText		BYTE	13,10,13,10,"Goodbye, and thanks for using my program!",13,10,0
comma			BYTE	", ",0

userInput		BYTE	255 DUP(?)
numberList		SDWORD	INPUTSIZE DUP(?)
numberAsString	BYTE	11 DUP(?)

.code
main PROC
	;1. introduction
	PUSH	OFFSET programTitle
	PUSH	OFFSET introText
	CALL	introduction

	;2. prompt user for 10 valid values
	PUSH	OFFSET promptText
	PUSH	OFFSET errorText
	PUSH	OFFSET userInput
	PUSH	SIZEOF userInput	
	
	MOV		ecx, INPUTSIZE			
	MOV		edi, OFFSET numberList

_buildNumberList:
	CALL	ReadVal
	MOV		[edi], ebx
	ADD		edi, 4
	LOOP    _buildNumberList

	;3. print list of numbers
	mDisplayString	OFFSET listText
	PUSH			OFFSET numberAsString

	mov				ecx, INPUTSIZE
	mov				esi, OFFSET numberList

_printList:
	mov				eax, [esi]
	CALL			WriteVal
	CMP				ecx, 1
	JBE				_printingFinished
	mDisplayString	OFFSET comma
	ADD				esi, 4
	LOOP			_printList
_printingFinished:

	;4. calculate and display sum 
	mDisplayString	OFFSET sumText
	PUSH			OFFSET numberAsString

	MOV				eax, 0					;eax will holding running sum
	MOV				ecx, INPUTSIZE
	MOV				esi, OFFSET numberList

_sum:
	ADD		eax, [esi]
	ADD		esi, 4
	LOOP	_sum
	CALL	WriteVal

	;4. calculate and display truncated average
	mDisplayString	OFFSET averageText
	CDQ
	MOV		ebx, INPUTSIZE
	IDIV	ebx
	CALL	WriteVal

	;5. display goodbye message
	PUSH	OFFSET goodbyeText
	CALL	farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ***************************************************************
; Name: introduction
;
; Displays title and program introduction
;
; Receives: address of programTitle and intro on system stack
; ***************************************************************
introduction	PROC
	PUSH    ebp
	MOV     ebp,esp

	mDisplayString [ebp+12]   	;print programTitle
	mDisplayString [ebp+8]    	;print intro text

	;mDisplayString (OFFSET extracredit_1)
	;mDisplayString (OFFSET extracredit_2)

	POP		ebp
	RET		8
introduction	ENDP

; ***************************************************************
; Name: ReadVal
;
; Description: Gets user input in the form of a string of digits, 
;			   converts the string to its numeric representation,
;			   validates user input, and stores value.
;
; Receives: address of promptText in stack		[ebp+24]
;		    address of errorText in stack		[ebp+20]
;		    address of userInput in stack		[ebp+16]
;	     	value of userInput size in stack	[ebp+12]
;			MAX (global)
;
; Returns: ebx (w/ numeric representation of user input)
; ***************************************************************
ReadVal	PROC
	PUSH	ecx
	PUSH    ebp
	MOV     ebp,esp

	mGetString [ebp+24], [ebp+16], [ebp+12] ;textOffset, inputOffest, inputSize
	
_validate:
	CLD
	MOV		ecx, eax		;set up counter
	MOV		ebx, 0			;set up register to hold user input as integer
	MOV		esi, [ebp+16]	;userInput offset moved to esi

	;check if input has a sign value
 	LODSB
	DEC		ecx
	CMP		ax, '-'
	JE		_negative
	CMP		ax, '+'
	JE		_positive

	;input has no sign value, reset to start of string
	DEC		esi
	INC		ecx

	;---------
	;convert string to integer - will iterate through user input string and will build an integer in
	;ebx if user input string is only composed of characters that represent numbers
	;---------
_positive:
 	LODSB

	;validate that (48d/'0') <= (current character in string) <= (57d/'9')
	CMP		ax, '0'
	JL		_error
	CMP		ax, '9'
	JG		_error

	;if character is valid number:
	SUB		ax, '0'
	XCHG	eax, ebx
	IMUL	eax, 10
	JC		_error
	ADD		ebx, eax
	MOV		eax, 0
	LOOP	_positive

	;validate that integer will fit in 32-bit register
	CMP		ebx, MAX
	JG		_error
	JMP		_finish

_negative:
 	LODSB

	;validate that (48d/'0') <= (current character in string) <= (57d/'9')
	CMP		ax, '0'
	JL		_error
	CMP		ax, '9'
	JG		_error

	;if character is valid number:
	SUB		ax, '0'
	XCHG	eax, ebx
	IMUL	eax, 10
	JC		_error
	ADD		ebx, eax
	MOV		eax, 0
	LOOP	_negative

	;validate that integer will fit in 32-bit register
	CMP		ebx, MAX
	JG		_error

	;negate integer
	NEG		ebx

_finish:
	POP		ebp
	POP		ecx
	RET		

	;request new value from user if user input does not meet requirements
_error:
	mGetString [ebp+20], [ebp+16], [ebp+12]
	JMP		_validate

   
ReadVal	ENDP

; ***************************************************************
; Name: WriteVal
;
; Description: Converts a numeric value into a string value and 
;			   prints the string.
;
; Preconditions: eax register must contain numberic value
;
; Receives: address of numberAsString in stack	[ebp+16]
;		    address of errorText in stack		[ebp+20]
;
; Returns:	numberAsString (string representation of integer)
; ***************************************************************
WriteVal	PROC
	PUSH	eax
	PUSH	ecx
	PUSH    ebp
	MOV     ebp,esp

	CDQ
	MOV		edx, 0
	MOV		ecx, 0
	MOV		ebx, 10
	MOV		edi, [ebp+16]

	CMP EAX, 0
	JL _negative					;will redirect number to have negative sign added

	;----
	;separate a number into individual numbers through division by popping the modulo
	;(or what is rightmost number) onto the stack until all digits are separated and on 
	;the stack. Then pop each number as a char onto numberAsString array
	;----
_loop:
	IDIV	ebx
	PUSH	edx
	MOV		edx, 0
	INC		ecx
	CMP		eax, 0
	JG		_loop

_buildNumberList:
	POP		eax
	ADD		eax, '0'				;convert to ASCII
	MOV		[edi], eax
	INC		edi
	LOOP    _buildNumberList

	mDisplayString [ebp+16]

	POP		ebp
	POP		ecx
	POP		eax
	RET		

_negative:
	PUSH	ebx
	NEG		eax
	MOV		ebx, '-'
	MOV		[edi], ebx				;add negative sign '-' 
	INC		edi
	POP		ebx
	JMP		_loop	

WriteVal	ENDP

; ***************************************************************
; Name: farewell
;
; Displays farewell to user
;
; Receives: address for goodbye text on stack
; ***************************************************************
farewell		PROC
	PUSH    ebp
	MOV     ebp,esp
	mDisplayString [ebp+8]    	;print goodbye text
	POP		ebp
	RET		8
farewell		ENDP

END main
