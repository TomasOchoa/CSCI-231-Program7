;// NAME: Tomas Ochoa 
;// DATE: 12/10/15
;// Prof James Ryder 
;// PROGRAM 7 (Macros Include File)

;// DEFINE COLORS 
	black	   	  	EQU 0 
	blue		   	EQU 1
	green	   		EQU 2
	cyan		  	EQU 3
	red		   		EQU 4
	magenta		    EQU 5  
	brown	   	 	EQU 6
	lightGray	    EQU 7
	gray		    EQU 8
	lightBlue	    EQU 9
	lightGreen 		EQU 10
	lightCyan	    EQU 11
	lightRed	    EQU 12
	lightMagenta    EQU 13
	yellow	   		EQU 14
	white	      	EQU 15

;// Macro to change the BG color 
mChangeBGColor MACRO BGcolor:REQ
	LOCAL toChange 
	.data
		toChange BYTE BGcolor			;// to change = BGcolor 
	.code 
	;// First got to make sure we ONLY change the BG color and KEEP original text 
		push eax 					;// push eax		
		mov  al, toChange			;// load BGcolor passed in 
		mov	bl, 16				;// to get complete color byte value, multiply
		mul	bl  					;// the BG  color by 16 and add it to the FG 
		mov	toChange, al 			;// toChange = ([BG color] * 16)
		mov	bl, white				;// adds the number repressented by white to the color byte 
		add	toChange, bl 			;// ([user color] * 16) + 15 = 
		
	;// Now actually change the BG color 
		mov al, toChange			;// make sore only al is read 
		call SetTextColor			;// set it
		call clrscr				;// refresh screen to display change 
ENDM 
;//***************************************************************************************
;// Macro to change the FG color 
mChangeFGColor MACRO FGcolor:REQ
	LOCAL toChange
	LOCAL currColors 
	LOCAL currBGcolor 
	.data
		toChange	  BYTE FGcolor		;// to change = color 
		currColors  BYTE ?			;// var to hold the current colors temporarily
		currBGColor BYTE ?			;// var to hold the current bg color temporarily
	.code 
		push eax 					;// push eax	
		push ebx 
	;// Get the current bg color first 
		call getTextColor			;// al = [background][forground]
		mov	currColors, al			;// al = currColors 
		mov	bl, 16				;//bl = 16
		div	bl					;// al now = [currCOlors] / 16 = current BG Color 
		mov	currBGcolor, al		;// Store it
			
	;// Now we can set it up and change the color 
		mov	al, currBGColor		;// load it to al 
		mov 	bl, 16				;// bl = 16 
		mul	bl					;// al = [al] * 16 
		add  al, toChange			;// add al the color passed in to make it a complete color byte
		call	SetTextColor			;// set it	
		call clrscr				;// clear screen to reflect change 
ENDM 
;//***************************************************************************************
;// Macro for changing both background and forground color. It takes two arguments and 
;// changes the colors. There is added code to check if colors wanted can be used 
mChangeBGandFGColor MACRO FG:REQ, BG:REQ
	LOCAL toChange 
	.data
	;// Set toChange to the correct color byte 
		toChange = FG + (BG * 16)
	.code 
		push eax
		mov	eax, toChange 
		call SetTextColor 
		call Clrscr 
ENDM 