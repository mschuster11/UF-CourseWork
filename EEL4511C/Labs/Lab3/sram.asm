; THIS IS MARK L SCHUSTER'S CODE MY DUDE PLEASE DONE COPY THIS BIIIIII
		.global	_c_int00


WDCR			.set 	0x7029		;Watchdog Register is at address 0x7029
PCLKCR3			.set	0x7020
stackAddr		.set 	0x400
sramAddrStart	.set	0x100000
sramAddrEnd		.set	0x13FFFF

GPAMUX1			.set	0x6F86
GPAMUX2			.set	0x6F88
GPADIR			.set	0x6F8A
GPADAT			.set	0x6FC0
GPAPUD			.set	0x6F8C

GPBMUX1			.set	0x6F96
GPBMUX2			.set	0x6F98
GPBDIR			.set    0x6F9A
GPBDAT			.set    0x6FC8
GPBPUD			.set    0x6F9C

GPCMUX1			.set	0x6FA6
GPCMUX2			.set	0x6FA8
GPCDIR			.set    0x6FAA
GPCDAT			.set    0x6FD0
GPCPUD			.set    0x6FAC

		.data
TEST1_ERROR_ADDR			.word 0x37, 0
TEST1_ERROR_VAL				.word 0

TEST2_ERROR_ADDR			.word 0, 0
TEST2_ERROR_VAL				.word 0

TEST3_ERROR_ADDR			.word 0, 0
TEST3_ERROR_VAL				.word 0

TESTERR						.word "$EE", 0
TEST1						.word "$AA", 0
TEST2						.word "$55", 0
TEST3						.word "$00", 0

		.text

_c_int00:
			EALLOW

			MOV	 AL, #0x0068					;Disable Watchdog Timer in case we want to run this code on our board
			MOV	 AR1, #WDCR
			MOV	 *AR1, AL

			MOV	SP, #stackAddr					; Init the stack pointer to 0x0400.

			LC PREP_LCD							; Prepare the GPIO registers used in interfacing the LCD.
			LC INIT_LCD							; Send the init commands to the LCD.



			LC INIT_SRAM
			LC SRAM_TEST3


PRGM_END:
			B PRGM_END, UNC


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		SRAM_TEST1
; Description:	Writes 0xAA to all SRAM locations and then checks for
;				0xAA at all written locations.
; Inputs:		None.
; Outputs:		None.
SRAM_TEST1:
			LC LCD_CLEAR_SCREEN					; Clear the CLD screen.
			MOVL XAR1, #sramAddrEnd				; Set the end addr of the SRAM.
			MOVL ACC, XAR1
			MOVL XAR0, #sramAddrStart			; Set the start addr of the SRAM.

TEST1_LOOP_WRITE:
			MOV *XAR0++, #0xAA 					; Write to the whole of the SRAM.
			CMPL ACC, XAR0
			B TEST1_LOOP_WRITE, NEQ
			MOVL XAR0, #sramAddrStart			; Reload the start addr of the SRAM.

TEST1_LOOP_READ:
			MOV AL, *XAR0++						; Loop through the SRAM checking that
			CMP AL, #0xAA 						; every value is as predicted.
			B TEST1_ERROR, NEQ
			MOVL ACC, XAR1
			CMPL ACC, XAR0
			B TEST1_LOOP_READ, NEQ
			PUSH #TEST1 						; If all values are correct, print success message to LCD.
			LC LCD_WRITE_STRING
			B TEST1_END, UNC

TEST1_ERROR:
			MOV AL, #1 							; If not, store the bad addr, and value to memory, then 
			MOV AH, #0 							; print the error message.
			SUBL XAR0, ACC
			MOV AL, *XAR0
			MOV AR1, #TEST1_ERROR_VAL
			MOV *AR1, AL
			MOVL XAR1, #TEST1_ERROR_ADDR
			MOVL *XAR1, XAR0
			PUSH #TESTERR
			LC LCD_WRITE_STRING

TEST1_END:
			LRET


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		SRAM_TEST2
; Description:	Writes 0x55 to all SRAM locations and then checks for
;				0x55 at all written locations.
; Inputs:		None.
; Outputs:		None.
SRAM_TEST2:
			LC LCD_CLEAR_SCREEN					; Clear the CLD screen.
			MOVL XAR1, #sramAddrEnd				; Set the end addr of the SRAM.
			MOVL ACC, XAR1
			MOVL XAR0, #sramAddrStart			; Set the start addr of the SRAM.

TEST2_LOOP_WRITE:
			MOV *XAR0++, #0x55 					; Write to the whole of the SRAM.
			CMPL ACC, XAR0
			B TEST2_LOOP_WRITE, NEQ
			MOVL XAR0, #sramAddrStart			; Reload the start addr of the SRAM.

TEST2_LOOP_READ:
			MOV AL, *XAR0++						; Loop through the SRAM checking that
			CMP AL, #0x55 						; every value is as predicted.
			B TEST2_ERROR, NEQ
			MOVL ACC, XAR1
			CMPL ACC, XAR0
			B TEST2_LOOP_READ, NEQ
			PUSH #TEST2 						; If all values are correct, print success message to LCD.
			LC LCD_WRITE_STRING
			B TEST2_END, UNC

TEST2_ERROR:
			MOV AL, #1 							; If not, store the bad addr, and value to memory, then 
			MOV AH, #0 							; print the error message.
			SUBL XAR0, ACC
			MOV AL, *XAR0
			MOV AR1, #TEST2_ERROR_VAL
			MOV *AR1, AL
			MOVL XAR1, #TEST2_ERROR_ADDR
			MOVL *XAR1, XAR0
			PUSH #TESTERR
			LC LCD_WRITE_STRING

TEST2_END:
			LRET


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		SRAM_TEST3
; Description:	Writes the lower two bytes of the current addr to each SRAM location
;				and then checks to make sure they are consistant.
; Inputs:		None.
; Outputs:		None.
SRAM_TEST3:
			LC LCD_CLEAR_SCREEN					; Clear the CLD screen.
			MOVL XAR1, #sramAddrEnd				; Set the end addr of the SRAM.
			MOVL ACC, XAR1
			MOVL XAR0, #sramAddrStart			; Set the start addr of the SRAM.
			MOVL XAR3, #0

TEST3_LOOP_WRITE:
			MOV *XAR0++, AR3					; Write to the whole of the SRAM.
			INC AR3
			CMPL ACC, XAR0
			B TEST3_LOOP_WRITE, NEQ
			MOVL XAR0, #sramAddrStart			; Reload the start addr of the SRAM.
			MOVL XAR3, #0

TEST3_LOOP_READ:
			MOV AL, *XAR0++						; Loop through the SRAM checking that
			CMP AL, AR3 						; every value is as predicted.
			B TEST3_ERROR, NEQ
			INC AR3
			MOVL ACC, XAR1
			CMPL ACC, XAR0
			B TEST3_LOOP_READ, NEQ
			PUSH #TEST3 						; If all values are correct, print success message to LCD.
			LC LCD_WRITE_STRING
			B TEST3_END, UNC

TEST3_ERROR:
			MOV AL, #1 							; If not, store the bad addr, and value to memory, then 
			MOV AH, #0 							; print the error message.
			SUBL XAR0, ACC
			MOV AL, *XAR0
			MOV AR1, #TEST3_ERROR_VAL
			MOV *AR1, AL
			MOVL XAR1, #TEST3_ERROR_ADDR
			MOVL *XAR1, XAR0
			PUSH #TESTERR
			LC LCD_WRITE_STRING

TEST3_END:
			LRET
;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		INIT_SRAM
; Description:	Inits the GPIO that interact with the SRAM.
; Inputs:		None.
; Outputs:		None.
INIT_SRAM:
			MOVL XAR0, #0
			MOV AR0, #PCLKCR3					; Enable the peripheral clock.
			TSET *AR0, #12
			MOV AR0, #GPAMUX2+1					; Enable XZCS6.L, XA19-17.
			TSET *AR0, #8
			TSET *AR0, #9
			TSET *AR0, #10
			TSET *AR0, #11
			TSET *AR0, #12
			TSET *AR0, #13
			TSET *AR0, #14
			TSET *AR0, #15
			MOV AR0, #GPBMUX1					; Enable XWE0.L, XA16.
			TSET *AR0, #12
			TSET *AR0, #13
			TSET *AR0, #14
			TSET *AR0, #15
			MOV AL, #0xFFFF 
			MOV AR0, #GPBMUX1+1					; Enable XA7-0.
			MOV *AR0, AL
			MOV AR0, #GPCMUX1					; Enable XD15-8.
			MOV *AR0, AL
			MOV AR0, #GPCMUX1+1					; Enable XD7-0.
			MOV *AR0, AL
			MOV AR0, #GPCMUX2					; Enable XA15-8.ZZ
			MOV *AR0, AL							

			LRET


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		PREP_LCD
; Description:	Prepares the GPIO registers to be used init
;				interfacing with the LCD
; Inputs:		None
; Outputs:		None
PREP_LCD:
			MOVL XAR0, #0
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
			MOVL XAR1, #0
			POP AR1								; Store the byte to be send.
			PUSH AR6							; Restore the return address.
			PUSH AR7
			MOVL XAR0, #0
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
			AND AL, #0x80						; AND the byte the determine the whether the next
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
			PUSH #0xF0							; Send the second nibble of the Display-On
			LC SEND_LCD_COMMAND					; Cursor-On, Position-On command(0xF of 0x0F).
			PUSH #0xF4
			LC SEND_LCD_COMMAND
			PUSH #0xF8
			LC SEND_LCD_COMMAND
			PUSH #0x00							; Send the first nibble of the clear
			LC SEND_LCD_COMMAND					; screen command(0x0 of 0x00).
			PUSH #0x04
			LC SEND_LCD_COMMAND
			PUSH #0x00
			LC SEND_LCD_COMMAND
			PUSH #0x10							; Send the second nibble of the clear
			LC SEND_LCD_COMMAND					; screen command(0x0 of 0x00).
			PUSH #0x14
			LC SEND_LCD_COMMAND
			PUSH #0x18
			LC SEND_LCD_COMMAND
			MOVL XAR6, #0x0000FFFF

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
			MOVL XAR5, #0
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
			PUSH #0xC0							; Send the first nibble of the new line
			LC SEND_LCD_COMMAND					; command(0xC of 0xC0).
			PUSH #0xC4
			LC SEND_LCD_COMMAND
			PUSH #0xC0
			LC SEND_LCD_COMMAND
			PUSH #0x00							; Send the second nibble of the new line
			LC SEND_LCD_COMMAND					; command(0x0 of 0xC0).
			PUSH #0x04
			LC SEND_LCD_COMMAND
			PUSH #0x08
			LC SEND_LCD_COMMAND

			LRET

;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		LCD_CLEAR_SCREEN
; Description:	Clears the screen of the LCD.
; Inputs:		None
; Outputs:		None
LCD_CLEAR_SCREEN:
			PUSH #0x00							; Send the first nibble of the clear
			LC SEND_LCD_COMMAND					; screen command(0x0 of 0x00).
			PUSH #0x04
			LC SEND_LCD_COMMAND
			PUSH #0x00
			LC SEND_LCD_COMMAND
			PUSH #0x00							; Send the second nibble of the clear
			LC SEND_LCD_COMMAND					; screen command(0x0 of 0x00).
			PUSH #0x04
			LC SEND_LCD_COMMAND
			PUSH #0x08
			LC SEND_LCD_COMMAND

			LRET
