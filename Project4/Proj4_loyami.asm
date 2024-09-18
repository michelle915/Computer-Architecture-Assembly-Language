TITLE Prime Numbers     (Proj4_loyami.asm)

; Author: Michelle Loya
; Last Modified: 2023
; OSU email address: loyami@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number:  4               Due Date: 2/26/2023
; Description: This program calculates and displays all the prime numbers when given
; a range by the user.

INCLUDE Irvine32.inc

; (insert macro definitions here)

RANGE_MIN = 1
RANGE_MAX = 4000

.data

programTitle	BYTE	"Prime Numbers by Michelle Loya",13,10,13,10,0
instruction_1	BYTE	"Enter the number of prime numbers you would like to see.",13,10,
						"I'll accept orders for up to 4000 primes.",13,10,13,10,0	
instruction_2	BYTE	"Enter the number of primes to display [1 ... 4000]: ",0
invalid			BYTE	"No primes for you! Number out of range. Try again.",13,10,0
userInput		DWORD	?
valid			DWORD	?			;boolean to check if input is valid
prime			DWORD	?			;boolean to check if number is prime
candidate		DWORD	1
divisor			DWORD	?
counter			DWORD	?
column_counter	DWORD	0
row_counter		DWORD	0			;row counter (EC #2)
space			BYTE	"	",0		;tab aligns columns (EC #1)
goodbye			BYTE	13,10,13,10,"Results certified by Michelle. Goodbye.",13,10,0

extracredit_1	BYTE	"**EC 1: Align the output columns.",13,10,0
extracredit_2	BYTE	"**EC 2: Extend the range to display up to 4000 primes. 20 rows per page.",13, 10, 13,10,0


.code
main PROC

	CALL	introduction
	CALL	getUserData
	CALL	showPrimes
	CALL	farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP


; ***************************************************************
; Name: introduction
;
; Displays title and program introduction
;
; Receives:
;		programTitle, instruction_1 (global variables)
; ***************************************************************
introduction	PROC
	MOV		EDX, OFFSET programTitle
	CALL	WriteString
	MOV		EDX, OFFSET instruction_1
	CALL	WriteString
	MOV		EDX, OFFSET extracredit_1
	CALL	WriteString
	MOV		EDX, OFFSET extracredit_2
	CALL	WriteString
	RET
introduction	ENDP

; ***************************************************************
; Name:getUserData
;
; Procedure will prompt user for value
;
; Receives: instruction_2, valid (global variables)
; ***************************************************************
getUserData		PROC
	_prompt_input:
	MOV		EDX, OFFSET instruction_2
	call	WriteString
	call	ReadDec

	CALL	validate
	CMP		valid, 0
	JZ		_prompt_input

	MOV		userInput, EAX
	CALL	CrLf
	RET
getUserData		ENDP

; ***************************************************************
; Name: Validate
;
; Sub-procedure will validate user input
;
; Preconditions: EAX register must be set to userInput
;
; Receives: RANGE_MIN, RANGE_MAX (constants) invalid (global variable)
;
; Returns: valid = boolean (1 = True; 0 = False)
; ***************************************************************
validate		PROC
	CMP		EAX, RANGE_MIN			
	JB		_invalid					
	CMP		EAX, RANGE_MAX
	JA		_invalid
	mov		valid, 1
	RET

	_invalid:
	MOV		EDX, OFFSET invalid
	CALL	WriteString   
	MOV		valid, 0
	RET
validate		ENDP

; ***************************************************************
; Name: showPrimes
;
; Procedure will display n prime numbers, based on user input
;
; Preconditions: userInput value must be a postive unsigned integer. Candidate
; must be initialized to one. Column_counter must be initialized to 0.
;
; Receives: userInput, candidate, row_counter, space (global variables)
; ***************************************************************
showPrimes		PROC
	MOV		ECX, userInput

	; --------------
	; Will loop through n prime numbers (n is based on user input). ECX is set to 
	; user input and will, ultimately, only decrement if a prime number is found.
	; Prime numbers will be printed in order that they are found
	;---------------
	_loopThroughSet: 
	CALL	isPrime
	CMP		prime, 1
	JE		_print
	_continue:
	INC		candidate
	LOOP	_loopThroughSet

	JMP		_exitProc

	_print:
	CMP		column_counter, 10
	JB		_addToCurrentRow
	CMP		row_counter, 19
	JE		_newPage

	;Will print on a new row
	CALL    CrLf
	MOV		EAX, candidate
	CALL	WriteDec
	MOV		EDX, OFFSET space
	CALL	WriteString
	MOV		column_counter, 1
	INC		row_counter
	JMP		_continue

	;Will print on same row
	_addToCurrentRow:
	MOV		EAX, candidate
	CALL	WriteDec
	MOV		EDX, OFFSET space
	CALL	WriteString
	INC		column_counter
	JMP		_continue

	;EC #2 Will create new page after 20 rows
	_newPage:
	CALL	CrLf
	CALL	CrLf
	CALL	WaitMsg
	MOV		row_counter, 0
	CALL	CrLf
	JMP		_continue

	_exitProc:
	RET

showPrimes		ENDP

; ***************************************************************
; Name: isPrime
;
; Sub-procedure will check whether a candidate number is prime
;
; Preconditions: candidate value must be a postive unsigned integer
;
; Postconditions: If the candidate passed is not prime, the ECX counter
; is increased by one so that the 'loopThroughSet' loop within the showPrimes
; procedure will iterate an additional time; only prime numbers will decrease
; the counter.
;
; Receives: candidate (global variable)
;
; Returns: prime = boolean (1 = True; 0 = False)
; ***************************************************************
isPrime		PROC
	PUSH	ECX

	;If candidate value is one, skip to notPrime
	CMP		candidate, 1
	JE		_notPrime

	;If candidate value is two, skip to prime
	CMP		candidate, 2
	JE		_prime

	MOV		EAX, candidate
	MOV		counter, EAX
	SUB		counter, 2

	MOV		ECX, counter
	MOV		divisor, 2

	; --------------
	; This loop will check to see if candidate number has a factor other than 1
	; or itself (meaning that it is not prime). 
	;---------------
	_checkFactors:
	MOV		EDX, 0
	MOV		EAX, candidate
	DIV		divisor
	CMP		EDX, 0
	JE		_notPrime
	INC		divisor
	LOOP	_checkFactors

	_Prime:
	POP		ECX
	MOV		prime, 1
	RET

	_notPrime:
	POP		ECX
	INC		ECX			; Allows 'loopThroughSet to only count prime numbers
	MOV		prime, 0
	RET
isPrime		ENDP

; ***************************************************************
; Name: farewell
;
; Displays farewell to user
;
; Receives:
;		goodbye (global variable)
; ***************************************************************
farewell		PROC
	MOV		EDX, OFFSET goodbye		
	CALL	WriteString	
	RET
farewell		ENDP

END main
