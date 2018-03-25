		.global		_c_int00	

WDCR			.set	0x7029
stackAddr		.set	0x400
minLocation		.set	0x9101

GPAMUX1			.set	0x6F86
GPADIR			.set	0x6F8A
GPADAT			.set	0x6FC0
GPAPUD			.set	0x6F8C

GPBMUX1			.set	0x6F96
GPBDIR			.set    0x6F9A
GPBDAT			.set    0x6FC8
GPBPUD			.set    0x6F9C


		.data

LCDStringName:
				.word	"YA BOI:", 0x00
LCDStringClass:
				.word	"Mark $chuster", 0x00


		.text
_c_int00:
			EALLOW

			MOV	 AL, #0x0068					;Disable Watchdog Timer in case we want to run this code on our board
			MOV	 AR1, #WDCR
			MOV	 *AR1, AL

			MOV	SP, #stackAddr					; Init the stack pionter to 0x0400.

			LC PREP_LCD							; Prepare the GPIO registers used in interfacing the LCD.
			LC INIT_LCD							; Send the init commands to the LCD.

			PUSH #LCDStringName 					; Pass the string addr to the LCD string print routine via the stack.
			LC LCD_WRITE_STRING

			LC LCD_NEW_LINE

			PUSH #LCDStringClass 					; Pass the string addr to the LCD string print routine via the stack.
			LC LCD_WRITE_STRING


PRGRM_END:
			B PRGRM_END, UNC					; End the program.




;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		PREP_LCD
; Description:	Prepairs the GPIO regesters to be used init
;				interfacing with the LCD
; Inputs:		None
; Outputs:		None
PREP_LCD:
			MOV AR0, #GPBMUX1					; Enable GPIO 33 & 32.
			MOV AL, *AR0
			AND AL, #0xFFF0
			MOV *AR0, AL
			MOV AR0, #GPBPUD					; Enable the pull-up resistors for GPIO 32 and 33.
			MOV AL, *AR0
			AND AL, #0xFFFC
			MOV *AR0, AL

			LRET


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		SEND_LCD_COMMAND
; Description:	Send a command to the LCD by bit-banging I2C
; Inputs:		Byte to be send the LCD.
; Outputs:		None
SEND_LCD_COMMAND:
			POP AR7								; Pop return addr from stack.
			POP AR6
			POP AR1								; Store the byte to be send.
			PUSH AR6							; Restore the return address.
			PUSH AR7
			MOV AR0, #GPBDIR					; Initiate the connection by sending the 
			MOV AL, AR1							; target I2C's addr.
			TSET *AR0, #0
			TSET *AR0, #1
			TCLR *AR0, #1
			TSET *AR0, #1
			TCLR *AR0, #0
			TCLR *AR0, #1
			TSET *AR0, #1
			TSET *AR0, #0
			TCLR *AR0, #0
			TCLR *AR0, #1
			TSET *AR0, #1
			TSET *AR0, #0
			TCLR *AR0, #0
			TCLR *AR0, #1
			TSET *AR0, #1
			TSET *AR0, #0
			TCLR *AR0, #0
			TCLR *AR0, #1
			TSET *AR0, #1
			TSET *AR0, #0
			TCLR *AR0, #0
			TCLR *AR0, #1
			TSET *AR0, #1
			TSET *AR0, #0
			TCLR *AR0, #0
			TCLR *AR0, #1
			TSET *AR0, #1
			TSET *AR0, #0
			TCLR *AR0, #1
			TSET *AR0, #1
			TCLR *AR0, #1
			TSET *AR0, #1
			TCLR *AR0, #0
			TSET *AR0, #0
			MOV AH, #8							; Load the counter for the byte processing
												; loop.
BIT_LOOP:
			PUSH AL								; Save the byte in the stack
			AND AL, #0x80						; AND the byte the determine the wether the next
			B ZERO, EQ							; next bit is a one or zero, and select the bit to send
			B ONE, UNC							; accordingly.

NEXT_BIT:
			POP AL								; After the bit has been sent, decrement the counter,
			LSL AL, #1							; and shift the byte to be sent left by one for the next
			DEC AH								; AND.
			CMP AH, #0							; Check how many bits are left to be sent, if zero, end the loop.
			B NEXT, EQ
			B BIT_LOOP, UNC						; If not, send another.

ZERO:
			TCLR *AR0, #1						; Send a zero by toggling the SCLK.
			TSET *AR0, #1
			B NEXT_BIT, UNC						; Jump back to the main loop.

ONE:
			TCLR *AR0, #0						; Send a one by setting the SDATA pin high,
			TCLR *AR0, #1						; toggling the SCLK, then setting SDATA low.
			TSET *AR0, #1
			TSET *AR0, #0
			B NEXT_BIT, UNC						; Jump back to the main loop.

NEXT:
			TCLR *AR0, #0						; Execute the terminating sequence.
			TCLR *AR0, #1
			TSET *AR0, #1
			TSET *AR0, #0
			TCLR *AR0, #1
			TCLR *AR0, #0
			
			LRET


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		INIT_LCD
; Description:	Init the LCD by sending it 0x33, 0x32, 0x28,
;				0x0F, 0x01
; Inputs:		None
; Outputs:		None
INIT_LCD:
			PUSH #0x30							; Send the first nibble of the first
			LC SEND_LCD_COMMAND					; Base LCD init command(0x3 of 0x33).
			PUSH #0x34
			LC SEND_LCD_COMMAND
			PUSH #0x30
			LC SEND_LCD_COMMAND
			PUSH #0x30							; Send the second nibble of the first
			LC SEND_LCD_COMMAND					; Base LCD init command(0x3 of 0x33).
			PUSH #0x34
			LC SEND_LCD_COMMAND
			PUSH #0x30
			LC SEND_LCD_COMMAND
			PUSH #0x30							; Send the first nibble of the second
			LC SEND_LCD_COMMAND					; Base LCD init command(0x3 of 0x32).
			PUSH #0x34
			LC SEND_LCD_COMMAND
			PUSH #0x30
			LC SEND_LCD_COMMAND
			PUSH #0x20							; Send the second nibble of the second
			LC SEND_LCD_COMMAND					; Base LCD init command(0x2 of 0x32).
			PUSH #0x24
			LC SEND_LCD_COMMAND
			PUSH #0x20
			LC SEND_LCD_COMMAND
			PUSH #0x20							; Send the first nibble of the 4-Bit,
			LC SEND_LCD_COMMAND					; 2-line mode command(0x2 of 0x28).
			PUSH #0x24
			LC SEND_LCD_COMMAND
			PUSH #0x20
			LC SEND_LCD_COMMAND
			PUSH #0x80							; Send the second nibble of the 4-Bit,
			LC SEND_LCD_COMMAND					; 2-line mode command(0x8 of 0x28).
			PUSH #0x84
			LC SEND_LCD_COMMAND
			PUSH #0x80
			LC SEND_LCD_COMMAND
			PUSH #0x00							; Send the first nibble of the Display-On,
			LC SEND_LCD_COMMAND					; Cursor-On, Position-On command(0x0 of 0x0F).
			PUSH #0x04
			LC SEND_LCD_COMMAND
			PUSH #0x00
			LC SEND_LCD_COMMAND
			PUSH #0xF0							; Send the second nibble of the Display-On,d
			LC SEND_LCD_COMMAND					; Cursor-On, Position-On command(0xF of 0x0F).
			PUSH #0xF4
			LC SEND_LCD_COMMAND
			PUSH #0xF8
			LC SEND_LCD_COMMAND
			PUSH #0x00							; Send the first nibble of the clear
			LC SEND_LCD_COMMAND					; screen command(0x0 of 0x01).
			PUSH #0x04
			LC SEND_LCD_COMMAND
			PUSH #0x00
			LC SEND_LCD_COMMAND
			PUSH #0x10							; Send the second nibble of the clear
			LC SEND_LCD_COMMAND					; screen command(0x0 of 0x01).
			PUSH #0x14
			LC SEND_LCD_COMMAND
			PUSH #0x18
			LC SEND_LCD_COMMAND
			MOV AR6, #0xFFF

DELAY_LOOP:
			BANZ DELAY_LOOP, AR6--				; Execute a delay for the LCD init to take place.

			LRET


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		LCD_WRITE_CHAR
; Description:	Write a character to the LCD. 
; Inputs:		The byte to be written.
; Outputs:		None
LCD_WRITE_CHAR:

			POP AR2								; Pop return addr from stack.
			POP AR3
			POP AL								; Store the character to be send.
			PUSH AR3							; Restore the return address.
			PUSH AR2
			MOV AH, AL 							; Copy the char to AH.
			PUSH AH 							; Save AH to preserve the upper nibble for later.
			AND AL, #0xF0 						; Bit-mask the lower nibble of the char.
			OR AL, #0x0D 						; OR the meta-data for the upper nibble into AL.
			PUSH AL 							; Send the first nibble to the LCD with enable off.
			LC SEND_LCD_COMMAND
			AND AL, #0xF0 						; Bit-mask the lower nibble of the char.
			OR AL, #0x09 						; OR the meta-data for the upper nibble into AL.
			PUSH AL 							; Send the first nibble to the LCD with enable on.
			LC SEND_LCD_COMMAND

			POP AH 								; Pop AH back from the stack.
			AND AH, #0x0F 						; Bit-mask the upper nibble of the char. 
			LSL AH, #4 							; Logically shift the nibble left four bits for the proper format.
			OR AH, #0x0D 						; OR the meta-data for the upper nibble into 
			PUSH AH 							; Send the second nibble to the LCD with enable off.
			LC SEND_LCD_COMMAND
			AND AH, #0xF0						; Bit-mask the upper nibble of the char. 
			OR AH, #0x09						; OR the meta-data for the upper nibble into 
			PUSH AH 							; Send the second nibble to the LCD with enable off.
			LC SEND_LCD_COMMAND

			LRET


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		LCD_WRITE_STRING
; Description:	Write a string to the LCD.
; Inputs:		The address of the string to be written.
; Outputs:		None
LCD_WRITE_STRING:
			POP AR7								; Pop return addr from stack.
			POP AR6
			POP AR5								; Store the address of the initial string index.
			PUSH AR6							; Restore the return address.
			PUSH AR7

STR_LOOP:	
			CMP *AR5, #0x0 						; Check if the subroutine has reached the NULL-terminator
			B ENDL, EQ							; of the string, if so end the subroutine.
			PUSH *AR5 							; Push the current character to be sent.
			LC LCD_WRITE_CHAR
			INC AR5								; Increment the index of the string.
			B STR_LOOP, UNC						; Repeat for the rest of the characters in the string.

ENDL:
			LRET


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		LCD_NEW_LINE
; Description:	Switches the current line of the LCD.
; Inputs:		None
; Outputs:		None
LCD_NEW_LINE:
			PUSH #0xC0							; Send the first nibble of the clear
			LC SEND_LCD_COMMAND					; screen command(0x0 of 0x00).
			PUSH #0xC4
			LC SEND_LCD_COMMAND
			PUSH #0xC0
			LC SEND_LCD_COMMAND
			PUSH #0x00							; Send the second nibble of the cled
			LC SEND_LCD_COMMAND					; screen command(0x0 of 0x00).
			PUSH #0x04
			LC SEND_LCD_COMMAND
			PUSH #0x08
			LC SEND_LCD_COMMAND

			LRET
