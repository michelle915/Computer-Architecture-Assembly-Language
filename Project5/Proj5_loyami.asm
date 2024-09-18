TITLE Generating, Sorting, & Counting Random integers     (Proj5_loyami.asm)

; Author: Michelle Loya
; Last Modified: 3/7/2023
; OSU email address: loyami@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number:  5               Due Date: 3/6/2023
; Description: This program generates 200 random integers between 15 and 50 (inclusive).
; The numbers will be displayed in a list, then they will be sorted in ascending
; order, the median value of the list will be displayed, then the sorted list
; will be displayed, and lastly, the number of occurances of each number within
; the range of 15 and 50 will be displayed.


INCLUDE Irvine32.inc

; (insert macro definitions here)

ARRAYSIZE = 200
LO = 15
HI = 50

.data
programTitle	BYTE	"Generating, Sorting, and Counting Random integers!",13,10,
						"by Michelle Loya",13,10,13,10,0
intro			BYTE	"This program generates 200 random integers between 15 and 50 (inclusive).",13,10,
						"The numbers will be displayed in a list, then they will be sorted in ascending",13,10,
						"order, the median value of the list will be displayed, then the sorted list",13,10,
						"will be displayed, and lastly, the number of occurances of each number within",13,10,
						"the range of 15 and 50 will be displayed.",13,10,0

unsortedText	BYTE	13,10,13,10,"Your unsorted random numbers:",13,10,0
medianText		BYTE	13,10,13,10,"The median value of the array: ",0
sortedText		BYTE	13,10,13,10,"Your sorted random numbers:",13,10,0
instancesText	BYTE	13,10,13,10,"Your list of instances of each generated number, starting with the smallest value:",13,10,0
goodbye			BYTE	13,10,13,10,"Goodbye, and thanks for using my program!",13,10,0

randArray		DWORD	ARRAYSIZE DUP(?)
counts			DWORD	(HI-LO+1) DUP(?)

;extracredit_1	BYTE	"**EC 1: ",13,10,0
;extracredit_2	BYTE	"**EC 2: ",13,10,13,10,0	

.code
main PROC
	;introduction
	PUSH	OFFSET programTitle
	PUSH	OFFSET intro
	CALL	introduction

	;build random array
	CALL	Randomize
	PUSH	OFFSET randArray
	CALL	fillArray

	;display list of unsorted random numbers
	PUSH	OFFSET unsortedText
	PUSH	OFFSET randArray
	PUSH	LENGTHOF randArray
	CALL	displayList

	;sort numbers in array into ascending order
	PUSH	OFFSET randArray
	CALL	sortList

	;display list of sorted random numbers
	PUSH	OFFSET sortedText
	PUSH	OFFSET randArray
	PUSH	LENGTHOF randArray
	CALL	displayList

	;will calculate and display mean of array
	PUSH	OFFSET medianText
	PUSH	OFFSET randArray
	CALL	displayMedian
	
	;generate instances array
	PUSH	OFFSET randArray
	PUSH	OFFSET counts
	CALL	countList

	;display list of instances
	PUSH	OFFSET instancesText
	PUSH	OFFSET counts
	PUSH	LENGTHOF counts
	CALL	displayList

	;display goodbye message
	PUSH	OFFSET goodbye
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
	MOV     edx, [ebp+12]   
	CALL    WriteString		;print programTitle
	MOV     edx, [ebp+8]    
	CALL    WriteString		;print intro text

	;MOV	EDX, OFFSET extracredit_1
	;CALL	WriteString
	;MOV	EDX, OFFSET extracredit_2
	;CALL	WriteString

	POP		ebp
	RET		8
introduction	ENDP

; ***************************************************************
; Name: fillArray
;
; Description: Procedure to put random numbers in an array
;
; Receives: address of randArray on system stack; LO, HI, ARRAYSIZE (globals)
;
; Returns: randArray (filled with random integers)
; ***************************************************************
fillArray	PROC
	PUSH    ebp
	MOV     ebp, esp
	MOV     ecx, ARRAYSIZE      ;count in ecx = ARRAYSIZE
	MOV     edi, [ebp+8]		;address of array in edi
	
_fillLoop:
	mov		eax, HI
	INC		eax					;will increment to include highest HI value
	call	RandomRange			;generates random integer between 0 - HI
	CMP		eax, LO
	JB		_fillLoop			;will regenerate number is less than LO
	MOV     [edi], eax			;add new number to array
	ADD     edi, 4
	LOOP    _fillLoop
	
	POP     ebp
	RET     8
fillArray	ENDP

; ***************************************************************
; Name: sortList
;
; Description: This procedure sorts an array of numbers into an ascending order
;			   via two loops that implement a bubble sort
;
; Preconditions: randArray must have been initialized with ARRAYSIZE number of random
;				 elements
;
; Receives: address of randArray in stack, ARRAYSIZE (global)
;
; Returns: randArray (with elements sorted in ascending order)
; ***************************************************************
sortList	PROC
	PUSH    ebp
	MOV     ebp, esp
	MOV		ecx, ARRAYSIZE		
	DEC		ecx					;ecx = outer loop counter

_outer:							
	MOV     esi, [ebp+8]		;address of array in esi	
	MOV		edx, ecx			;sets inner loop counter to ecx

_inner:
	MOV		eax, [esi]			;eax = left value
	MOV		ebx, [esi+4]		;ebx = right value
	CMP		eax, ebx
	JB		_skipExchange		;skip exchange if left value < right value
	CALL	exchangeElements	;exchange if left value > right value
_skipExchange:
	ADD		esi, 4
	DEC		edx
	CMP		edx, 0
	JA		_inner				

	LOOP   _outer

	POP     ebp
	RET     8
sortList	ENDP

; ***************************************************************
; Name: exchangeElements
;
; Description: This procedure will exchange two adjacent values on
;			   an array.
;
; Preconditions: esi must be pointed at at the address where the new
;				 left value (or the lesser value) will go. ebx must be
;				 holding lesser value and eax must be holding greater
;				 value
;
; Receives: esi, ebx, eax register values
;
; Returns: left/[esi] is set to ebx (lesser value)
;		   right/[esi+4] is set to eax (greater value)	
; ***************************************************************
exchangeElements	PROC
	mov		[esi], ebx
	mov		[esi+4], eax

	RET
exchangeElements	ENDP

; ***************************************************************
; Name: displayMedian
;
; Description: This procedure calculates the median number of an
;			   array and displays then displays that number
;
; Preconditions: randArray must have been initialized with ARRAYSIZE number of random
;				 elements and randArray must have been sorted in ascending order
;
; Receives:	address for medianText and randArray on stack, global ARRAYSIZE
; ***************************************************************
displayMedian	PROC
	PUSH    ebp
	MOV     ebp, esp

	;print medianText
	MOV     edx, [ebp+12]   
	CALL    WriteString		
	
	MOV     esi, [ebp+8]	;address of array in esi
	
	;evaluate if array has an odd or even # of elements
	MOV		eax, ARRAYSIZE
	MOV		ebx, 2
	MOV		edx, 0
	DIV		ebx
	CMP		edx, 0
	JA		_oddArray				;JMP to odd array

	;procedure for even array
	MOV		ebx, [esi+eax*4]
	MOV		eax, [esi+eax*4-4]
	ADD		eax, ebx
	MOV		ebx, 2
	DIV		ebx
	CMP		edx, 0
	JE		_printMedian
	INC		eax						;roundup
	JMP		_printMedian

	;procedure for odd array
	_oddArray:
	MOV     eax, [esi+eax*4]

	;print median
	_printMedian:
	CALL    WriteDec

	POP     ebp
	RET     8
displayMedian	ENDP

; ***************************************************************
; Name: displayList
;
; Description: Procedure to display an array
;
; Preconditions: Array must be initialized
;
; Receives: address of some text and address of some array on system stack;
;			value of array length
; ***************************************************************
displayList	PROC
	PUSH    ebp
	MOV     ebp,esp

	MOV     edx, [ebp+16]   
	CALL    WriteString		;display text

	MOV     ecx,[ebp+8]		;count in ecx = ARRAYSIZE
	MOV     esi,[ebp+12]	;address of array in esi
	MOV		ebx,0			;column counter

	_displayLoop:
	CMP		ebx, 20			
	JB		_print			

	;Create new row & reset column counter to 0
	CALL    CrLf
	MOV		ebx, 0

	_print:
	MOV     eax,[esi]		
	CALL    WriteDec		;display element
	MOV     al,32
	CALL    WriteChar		;display space (" ")
	ADD		esi,4
	INC		ebx
	LOOP    _displayLoop

	POP		ebp
	RET		8
displayList	ENDP

; ***************************************************************
; Name: countList
;
; Description: This procedure fills an array (the counts array) with the # of times
;			   each value in the range [LO, HI] is seen in randArray
;
; Preconditions: randArray must be initialized and sorted into ascending order
;
; Receives: address for counts array and randArray on stack; globals LO, HI, ARRAYSIZE
;
; Returns: counts array (filled with # occurances for [LO, HI] values)
; ***************************************************************
countList	PROC
	PUSH    ebp
	MOV     ebp, esp
	MOV     ecx, ARRAYSIZE      ;count in ecx = ARRAYSIZE
	MOV     edi, [ebp+8]		;address of counts array in edi
	MOV     esi, [ebp+12]		;address of randArray in edi
	
	MOV		edx, 0				;occurance counter
	MOV		eax, LO				;eax = comparison number
	
_countingLoop:
	CMP		ecx, 0
	JE		_storeCount			;Will skip to storeCount if all numbers in randArray have been checked

	MOV		ebx, [esi]			;ebx = potential occurance
	CMP		eax, ebx
	JNE		_storeCount			;store count if comparison number != potential occurance

	;increaseCount
	INC		edx					;increase count if comparison number = potential occurance
	ADD		esi, 4
	LOOP	_countingLoop		

_storeCount:
	MOV     [edi], edx			;add count to array
	MOV		edx, 0				;reset occurance counter
	ADD     edi, 4				
	INC		eax
	CMP		eax, HI
	JBE		_countingLoop		;exit loop once all values within [LO, HI] have been checked
	
	POP     ebp
	RET     8
countList	ENDP

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
	MOV     edx, [ebp+8]    
	CALL    WriteString			;print goodbye text
	POP		ebp
	RET		8
farewell		ENDP

END main
