TITLE Debug Lab File     (DebugLab.asm)

; Author: Stephen Redfield
; Last Modified: 10/01/2020
; OSU email address: redfiels@oregonstate.edu
; Course number/section:   CS271 Section 40x
; Project Number:  -               Due Date: -
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

MAX_FILE_SIZE = 1400

.data
greeting        BYTE    "Welcome to the Debugging Tutorial Program!",13,10
                BYTE    "You are User Number ",0
fileName        BYTE    "TestText.txt",0
fileHandle      DWORD   ?
fileBuffer      BYTE    MAX_FILE_SIZE DUP(?)
bytesRead       DWORD   ?
fileNameError   BYTE    "Invalid Filename... Please ensure the file is in the same directory as the ASM file.",0
fileReadError   BYTE    "Error in Reading File.",0

.code
main PROC
  ; Greet the User
  CALL  greetUser

  ; Attempt to Open Input File
  MOV   EDX, OFFSET fileName
  CALL  OpenInputFile
  MOV   fileHandle, EAX

  ; Verify correct filename/file path
  CMP   EAX, INVALID_HANDLE_VALUE
  JNE   _validName    ; Filename Checks Out!
  MOV   EDX, OFFSET fileNameError   ; Print Filename Error!  
  CALL  WriteString    ; Notify User
  CALL  CrLf
  JMP   _EndFile       ; Quit

;  Attempt to Read Input File to Memory
_validName:
  MOV   EAX, fileHandle
  MOV   EDX, OFFSET fileBuffer 
  MOV   ECX, MAX_FILE_SIZE - 1
  CALL  ReadFromFile
  MOV   bytesRead, EAX
  JNC   _validRead    ;Jump if No Error in Reading File
  MOV   EDX, OFFSET fileReadError
  CALL  WriteString    ; Notify User of File Read Error
  CALL  CrLf
  JMP   _EndFile       ; Quit
  
;  Attempt to Print data from file as ASCII characters (hopefully no NULLs)
_validRead:
  MOV   EDX, OFFSET fileBuffer
  CALL  WriteString
  CALL  CrLf

_EndFile:

  Invoke ExitProcess,0  ; exit to operating system
main ENDP

greetUser PROC
  MOV   EDX, OFFSET greeting
  CALL  WriteString
  MOV   EAX, 064h
  CALL  WriteHex
  CALL  CrLf
  CALL  CrLf
  RET
greetUser ENDP
; (insert additional procedures here)

END main
