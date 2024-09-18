TITLE Sum, Min, Max & Average     (Proj3_loyami.asm)

; Author: Michelle Loya
; Last Modified: 2023
; OSU email address: loyami@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number:  3               Due Date: 2/12/2023
; Description: This program will calculate the sum, min, max and average of a set of numbers inputted by
; the user.

INCLUDE Irvine32.inc

RANGE_1_MIN = -200
RANGE_1_MAX = -100
RANGE_2_MIN = -50
RANGE_2_MAX = -1

.data

programTitle	BYTE	"Sum, Min, Max & Average by Michelle Loya",13,10,13,10,0
greeting_1		BYTE	"What's your name? ", 0
userName		BYTE	33 DUP(0)
greeting_2		BYTE	13,10,"Nice to meet you, ",0

instruction_1	BYTE	"This program will calculate the sum, min, max and average of a set of numbers",13,10,
						"inputted by you, the user. The values that you choose must be within the range ",13,10,
						"of [",0	
instruction_2	BYTE	"] or [",0
instruction_3	BYTE	"]. To conclude your list, enter a positive value.",13,10,13,10,0
comma			BYTE	", ",0

prompt			BYTE	"Enter a value: ",0
invalid			BYTE	"This number is not within the acceptable range!",13,10,0

min				SDWORD	RANGE_2_MAX
max				SDWORD	RANGE_1_MIN
count			SDWORD	0
sum				SDWORD	?
average			SDWORD	?
remainder		SDWORD	?
two				SDWORD	2

result_count_1	BYTE	13,10,"You entered ",0
result_count_2	BYTE	" valid numbers.",13,10,0
result_max		BYTE	13,10,"Maximum: ",0
result_min		BYTE	13,10,"Minimum: ",0
result_sum		BYTE	13,10,"Sum: ",0
result_avg		BYTE	13,10,"Rounded Average: ",0

no_inputs		BYTE	13,10,"You did not input any valid numbers!",13,10,0
goodbye			BYTE	13,10,"See yah later!!",13,10,0

.code
main PROC

;Display program title
	mov		EDX, OFFSET programTitle
	call	WriteString

;Greet user
	mov		edx, OFFSET greeting_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32
	call	ReadString
	mov		edx, OFFSET greeting_2
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf

;Display instructions
	mov		EDX, OFFSET instruction_1
	call	WriteString					;Display: "This program will calculate... of ["
	mov		EAX, RANGE_1_MIN
	call	WriteInt					;Display: RANGE_1_MIN
	mov		EDX, OFFSET comma
	call	WriteString					;Display: ", "
	mov		EAX, RANGE_1_MAX
	call	WriteInt					;Display: RANGE_1_MAX
	mov		EDX, OFFSET instruction_2
	call	WriteString					;Display: "] or ["
	mov		EAX, RANGE_2_MIN
	call	WriteInt					;Display: RANGE_2_MIN
	mov		EDX, OFFSET comma
	call	WriteString					;Display: ", "
	mov		EAX, RANGE_2_MAX
	call	WriteInt					;Display: RANGE_2_MAX
	mov		EDX, OFFSET instruction_3
	call	WriteString					;Display: "]. To conclude your list, enter a positive value."

;Assess user input
	_prompt_input:
	mov		EDX, OFFSET prompt
	call	WriteString					;"Enter a value: "
	call	ReadInt        

	JNS		_results					;will continue to results if input is nonnegative

	;check if user input is valid
	CMP		EAX, RANGE_1_MIN			
	JL		_invalid					;invalid if: value < RANGE_1_MIN
	CMP		EAX, RANGE_1_MAX
	JG		_greater_than_first_range
	JMP		_valid

	_greater_than_first_range:
	CMP		EAX, RANGE_2_MIN		
	JL		_invalid					;invalid if: RANGE_1_MIN < value < RANGE_2_MIN
	CMP		EAX, RANGE_2_MAX
	JG		_invalid					;invalid if: value > RANGE_2_MAX
	JMP		_valid

	;prompt new input if user input is invalid
	_invalid:
	mov		EDX, OFFSET invalid
	call	WriteString   
	JMP		_prompt_input

	_valid:
	;checks if user input is less than all other inputted values
	CMP		EAX, min			
	JL		_new_min

	;checks if user input is greater than all other inputted values
	CMP		EAX, max			
	JG		_new_max

	;adds new input to sum calculation
	ADD		sum, EAX

	;increases count of inputted values
	ADD		count, 1

	;prompts user to enter another value
	JMP		_prompt_input

	;Sets new minimun if user input is less than all other inputted values
	_new_min:
	mov		min, EAX
	JMP		_valid

	;Sets new maximum if user input is greater than all other inputted values
	_new_max:
	mov		max, EAX
	JMP		_valid

;Calculates average and displays sum, min, max & average
	_results:
	;Check if user did not input any numbers
	CMP		count, 0
	JNE		_calculations
	mov		EDX, OFFSET no_inputs
	call	WriteString	
	JMP		_goodbye

	_calculations:
	;Calculate average
	MOV		EAX, sum
	CDQ
	IDIV	count
	MOV		average, EAX
	MOV		remainder, EDX

	MOV		EAX, count
	CDQ
	IDIV	two
	
	CMP		remainder, EAX
	JG		_round_up
	JMP		_display_results

	_round_up:
	ADD		average, 1

	_display_results:
	;Display results
	mov		EDX, OFFSET result_count_1	;Displays: "You entered "
	call	WriteString	
	mov		EAX, count					;Displays: Count
	call	WriteInt
	mov		EDX, OFFSET result_count_2	;Displays: " valid numbers."
	call	WriteString	

	mov		EDX, OFFSET result_max		;Displays: "Maximum: "
	call	WriteString	
	mov		EAX, max					;Displays: Max
	call	WriteInt

	mov		EDX, OFFSET result_min		;Displays: "Minimum: "
	call	WriteString	
	mov		EAX, min					;Displays: Min
	call	WriteInt

	mov		EDX, OFFSET result_sum		;Displays: "Sum: "
	call	WriteString	
	mov		EAX, sum					;Displays: sum
	call	WriteInt

	mov		EDX, OFFSET result_avg		;Displays: "Rounded Average: "
	call	WriteString	
	mov		EAX, average				;Displays: average
	call	WriteInt

	_goodbye:
	mov		EDX, OFFSET goodbye		;Displays: "See yah later!!"
	call	WriteString	

	Invoke ExitProcess,0	; exit to operating system
main ENDP

END main
