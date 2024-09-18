TITLE Elementary Arithmetic     (Proj1_loyami.asm)

; Author: Michelle Loya
; Last Modified: 1/28/2023
; OSU email address: loyami@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 1                Due Date: 1/29/2023
; Description: The program performs elementary integer arithmetic operations. The program will
; ask users to input three numbers (from largest to smallest) and will return some simple
; sums and differences between the numbers

INCLUDE Irvine32.inc

.data

programTitle	BYTE	"Elementary Arithmetic by Michelle Loya",0
instructions	BYTE	"Enter 3 numbers A > B > C, and I'll show you the sums and differences.",0
numPromptA		BYTE	"First number: ",0
numA			SDWORD	?
numPromptB		BYTE	"Second number: ",0
numB			SDWORD	?
numPromptC		BYTE	"Third number: ",0
numC			SDWORD	?
sumAB			SDWORD	?
difAB			SDWORD	?
sumAC			SDWORD	?
difAC			SDWORD	?
sumBC			SDWORD	?
difBC			SDWORD	?
sumABC			SDWORD	?
plus			BYTE	" + ",0
minus			BYTE	" - ",0
equals			BYTE	" = ",0
goodbye			BYTE	"Thanks for using Elementary Arithmetic! Goodbye!",0

extraCredit1	BYTE	"**EC #1: This program repeats until the user chooses to quit.",0
againPrompt		BYTE	"Input more numbers? (Yes/No) ",0
userResponse	BYTE	33 Dup(0)

extraCredit2	BYTE	"**EC #2: This program verifies the numbers are in descending order.",0
error1			BYTE	"ERROR: B must be less than A!",0
error2			BYTE	"ERROR: C must be less than B!",0

extraCredit3	BYTE	"**EC #3: This program handles negative results and additionally computes B-A, C-A, C-B, C-B-A",0
difBA			SDWORD	?
difCA			SDWORD	?
difCB			SDWORD	?
difCBA			SDWORD	?

extraCredit4	BYTE	"**EC #4: This program will also calculate and display the quotients and remainders of A/B, A/C, B/C.",0
quotientAB		SDWORD	?
remainderAB		SDWORD	?
quotientAC		SDWORD	?
remainderAC		SDWORD	?
quotientBC		SDWORD	?
remainderBC		SDWORD	?
dividedBy		BYTE	" / ",0
remainder		BYTE	" Remainder: ",0

.code
main PROC

; 1. Introduction
	mov		EDX, OFFSET programTitle
	call	WriteString
	call	CrLf
	call	CrLf
	mov		EDX, OFFSET extraCredit1
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET extraCredit2
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET extraCredit3
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET extraCredit4
	call	WriteString
	call	CrLf
	call	CrLf
	mov		EDX, OFFSET instructions
	call	WriteString
	call	CrLf

_start:								;the program will restart to this point (EC #1)
; 2. Get the data
    mov		EDX, OFFSET numPromptA
	call	WriteString
	call	ReadInt
	mov		numA, EAX

	_input2:
	mov		EDX, OFFSET numPromptB
	call	WriteString
	call	ReadInt
	CMP		numA, EAX
	JLE		_error1					;will jump to an error is B is not less than A (EC #3)
	mov		numB, EAX
	JMP		_continue1

	_error1:
	mov		EDX, OFFSET error1
	call	WriteString
	call	CrLf
	JMP		_input2

	_continue1:
	_input3:
	mov		EDX, OFFSET numPromptC
	call	WriteString
	call	ReadInt
	CMP		numB, EAX
	JLE		_error2					;will jump to an error is C is not less than B (EC #3)
	mov		numC, EAX
	call	CrLf
	JMP		_continue2

	_error2:
	mov		EDX, OFFSET error2
	call	WriteString
	call	CrLf
	JMP		_input3

	_continue2:
; 3. Calculate values
	;Sum of first and second value
	MOV		EAX, numA
	MOV		EBX, numB
	ADD		EAX, EBX
	MOV		sumAB, EAX

	;Difference of first and second value
	SUB		EAX, EBX
	SUB		EAX, EBX
	MOV		difAB, EAX

	;Sum of first and third value
	MOV		EAX, numA
	MOV		EBX, numC
	ADD		EAX, EBX
	MOV		sumAC, EAX

	;Difference of first and third value
	SUB		EAX, EBX
	SUB		EAX, EBX
	MOV		difAC, EAX

	;Sum of second and third value
	MOV		EAX, numB
	MOV		EBX, numC
	ADD		EAX, EBX
	MOV		sumBC, EAX

	;Sum of all value 
	ADD		EAX, numA
	MOV		sumABC, EAX

	;Difference of second and third value
	MOV		EAX, numB
	MOV		EBX, numC
	SUB		EAX, EBX
	MOV		difBC, EAX

; 4. Display the results
	;Display sum of first and second value
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, sumAB
	call	WriteInt
	call	CrLf

	;Display difference of first and second value
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, difAB
	call	WriteInt
	call	CrLf

	;Display sum of first and third value
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, sumAC
	call	WriteInt
	call	CrLf

	;Display difference of first and third value
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, difAC
	call	WriteInt
	call	CrLf

	;Display sum of second and third value
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, sumBC
	call	WriteInt
	call	CrLf

	;Display difference of second and third value
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, difBC
	call	WriteInt
	call	CrLf

	;Display sum of all value 
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET plus
	call	WriteString
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, sumABC
	call	WriteInt
	call	CrLf
	call	CrLf

; EC#4. Calculate and display B-A, C-A, C-B, C-B-A
	;Difference of B and A
	MOV		EAX, numB
	MOV		EBX, numA
	SUB		EAX, EBX
	MOV		difBA, EAX

	;Difference of C and A
	MOV		EAX, numC
	MOV		EBX, numA
	SUB		EAX, EBX
	MOV		difCA, EAX

	;Difference of C and B
	MOV		EAX, numC
	MOV		EBX, numB
	SUB		EAX, EBX
	MOV		difCB, EAX

	;Difference of C and B
	MOV		EBX, numA
	SUB		EAX, EBX
	MOV		difCBA, EAX

	;Display difference of B and A
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, difBA
	call	WriteInt
	call	CrLf

	;Display difference of C and A
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, difCA
	call	WriteInt
	call	CrLf

	;Display difference of C and B
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, difCB
	call	WriteInt
	call	CrLf

	;Display difference of C and B and A
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET minus
	call	WriteString
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, difCBA
	call	WriteInt
	call	CrLf
	call	CrLf

; EC#4. Calculate and display quotients
	;Calculate division of first and second value
	MOV		EAX, numA
	CDQ
	IDIV	numB
	MOV		quotientAB, EAX
	MOV		remainderAB, EDX

	;Display of division of first and second value
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET dividedBy
	call	WriteString
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, quotientAB
	call	WriteInt
	mov		EDX, OFFSET remainder
	call	WriteString
	mov		EAX, remainderAB
	call	WriteInt
	call	CrLf

	;Calculate division of first and third value
	MOV		EAX, numA
	CDQ
	IDIV	numC
	MOV		quotientAC, EAX
	MOV		remainderAC, EDX

	;Display of division of first and third value
	mov		EAX, numA
	call	WriteInt
	mov		EDX, OFFSET dividedBy
	call	WriteString
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, quotientAC
	call	WriteInt
	mov		EDX, OFFSET remainder
	call	WriteString
	mov		EAX, remainderAC
	call	WriteInt
	call	CrLf

	;Calculate division of second and third value
	MOV		EAX, numB
	CDQ
	IDIV	numC
	MOV		quotientBC, EAX
	MOV		remainderBC, EDX

	;Display of division of second and third value
	mov		EAX, numB
	call	WriteInt
	mov		EDX, OFFSET dividedBy
	call	WriteString
	mov		EAX, numC
	call	WriteInt
	mov		EDX, OFFSET equals
	call	WriteString
	mov		EAX, quotientBC
	call	WriteInt
	mov		EDX, OFFSET remainder
	call	WriteString
	mov		EAX, remainderBC
	call	WriteInt
	call	CrLf
	call	CrLf

; EC#1. Asks user if they which to restart program
	mov		EDX, OFFSET againPrompt
	call	WriteString
	mov		EDX, OFFSET userResponse
	mov		ECX, 32
	call	ReadString
	call	CrLf

	CMP		EAX, 3
	JE		_start				;will restart program if user answers 'Yes'
	
_exit:
; 5. Say goodbye
	mov		EDX, OFFSET goodbye
	call	WriteString
	call	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
