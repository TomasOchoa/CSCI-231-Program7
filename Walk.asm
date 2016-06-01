;// NAME: Tomas Ochoa 
;// DATE: 12/10/15
;// Prof James Ryder 
;// PROGRAM 7 (Modified Walk.asm Code)

;// Drunkard's Walk (Walk.asm)
;// Drunkard's walk program. The professor starts at
;// coordinates 25, 25 and wanders around the immediate area.

INCLUDE Irvine32.inc
INCLUDE MyMacros.inc 

WalkMax = 50
StartX = 25
StartY = 25

DrunkardWalk STRUCT
	path COORD WalkMax DUP(<0,0>)
	pathsUsed WORD 0
DrunkardWalk ENDS

DisplayPosition PROTO currX:WORD, currY:WORD

;// -------------------- DATA SEGMENT -------------------
.data
	aWalk DrunkardWalk <>
	prompt1	BYTE "BG color changed...",0
	prompt2	BYTE "FG color changed...",0
	prompt3	BYTE "Both FG and BG changed...",0

;// -------------------- MAIN PROCEDURE ------------------
.code
main PROC
;// Use the first macro to change the background color 
;// and prompt user it was done 
	mChangeBGColor gray
	mov edx, OFFSET prompt1 
	call WriteString
	call CRLF
	call WaitMsg
	call CRLF
	
;// (Continue program...)
	mov esi,OFFSET aWalk
	call TakeDrunkenWalk
	call WaitMsg

;// Use the second macro to change the forground color 
;// and prompt user it was done 
	mChangeFGColor black
	mov edx, OFFSET prompt2
	call WriteString
	call CRLF
	call WaitMsg
	call CRLF
	
;// Use Last macro to change both colors 
	mChangeBGandFGColor blue, white 
	mov edx, OFFSET prompt3
	call WriteString
	call CRLF

;// end main 
	exit
main ENDP
;//-------------------------------------------------------
TakeDrunkenWalk PROC
	LOCAL currX:WORD, currY:WORD
;//
;// Takes a walk in random directions (north, south, east,
;// west).
;// Receives: ESI points to a DrunkardWalk structure
;// Returns: the structure is initialized with random values
;//-------------------------------------------------------
	pushad
;// Use the OFFSET operator to obtain the address of the
;// path, the array of COORD objects, and copy it to EDI.
	mov edi,esi
	add edi,OFFSET DrunkardWalk.path
	mov ecx,WalkMax ; loop counter
	mov currX,StartX ; current X-location
	mov currY,StartY ; current Y-location
Again:
;// Insert current location in array.
	mov ax,currX
	mov (COORD PTR [edi]).X,ax
	mov ax,currY
	mov (COORD PTR [edi]).Y,ax
	INVOKE DisplayPosition, currX, currY
	mov eax, 10							;// choose a direction (0-9)
	call RandomRange

	.IF (eax == 0)							;// North
		inc currY
	.ELSEIF (eax == 1)						;// South
		dec currY
	.ELSEIF (eax == 2)						;// West
		dec currX
	.ELSEIF (eax == 3)						;// East
		inc	currX
	.ELSEIF (eax == 4)
		inc	currX 
	.ELSE								;// anthying over 5 is same direction
		dec currY				
	.ENDIF

	add edi,TYPE COORD						;// point to next COORD
	loop Again

Finish:
	mov (DrunkardWalk PTR [esi]).pathsUsed, WalkMax
	popad
	ret
TakeDrunkenWalk ENDP
;//-------------------------------------------------------
DisplayPosition PROC currX:WORD, currY:WORD
;//
;// Display the current X and Y positions.
;//-------------------------------------------------------
.data
	commaStr BYTE ",",0
.code
pushad
	movzx eax,currX					;// current X position
	call WriteDec
	mov edx,OFFSET commaStr				;// "," string
	call WriteString
	movzx eax,currY					;// current Y position
	call WriteDec
	call Crlf
	popad
	ret
DisplayPosition ENDP
END main