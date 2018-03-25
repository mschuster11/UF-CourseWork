;****************************************************************************************
; file = stack1.asm
; Quick examples of how to use the stack and subroutine calls.
; Dr. Karl Gugel, September/2009
;
; To be assembled using Code Composer Studio which requires a linker command
; file to tell CCR where to place code & data into DSP SRAM.
; The command file used = KG_RAM_link1.cmd
; Important Code locations:
;		.text	RAML1   (internal DSP memory) starting address = 09000 Hex, 4K Words
;		.data   RAML2	(internal DSP memory) starting address = 0A000 Hex, 4K Words
;		.bss	RAML3	(internal DSP memory) starting address = 0B000 Hex, 4K Words
;		.stack	RAMM1	(internal DSP memory) starting address = 0400  Hex, 1K Words
;
		.global		_c_int00	;This assembler directive allows _c_int00 to be a
						;global variable. This tells the linker where your
						;program (.text code) begins and where to boot from.
;
;****************************************************************************************
;***************************** Program Constants ****************************************
vector_len	.set		0x7		;length of test vector
stack_addr	.set		0x400		;the first address of stack memory
WDCR		.set		0x7029		;Watchdog Register is at address 0x7029
;****************************************************************************************
;******************* DATA ALLOCATION SECTION - Variables/Data ***************************
		.data				;data section, see the command linker file, starting at 0xA000.
vector 		.word 1,2,3,4,5,6,7 ;simple test vector
						;.global directive lets you to see the assigned addresses in map file.
		.global				vector,vector_len
;****************************************************************************************

;************************ Stack & Subroutine Program Example ****************************
		.text			;Program section, see command linker file, program code starts at 0x9000
_c_int00:				;This label tells the linker where the entry (starting) point for
					;the first instruction in your program.

		EALLOW				;Enable Protected resiter write. Needed to change control registers.

		MOV		AL,#0x0068	;Disable Watchdog Timer in case we want to run this code on our board
		MOV		AR1,#WDCR
		MOV		*AR1,AL

		MOV		SP,#stack_addr	;Initialize the SP to point to Stack Memory (internal DSP RAM)

		MOV		AL,#0xffff	;set stack mem to FFFF so that we can see changes to thsi mem
		MOV		AR1,#0x6	;number of mem locations to set to FFFF
		MOV		AR0,#0x400	;starting addr of stack memory
LOOP1:		MOV		*AR0,AL
		INC		AR0
		DEC		AR1
		B		LOOP1,NEQ


		MOV		AL,#vector_len	;save vector length on the stack for future use
		PUSH	AL

		MOV		AR0,#vector	;save vector starting address on the stack for future use
		PUSH	AR0

		LC		Reverse		;call subroutine Reverse, this routine automaticall pushes
                                                ;the two word return addr onto the stack

END1:	B		END1,UNC		;infinite loop to just keep us from trying to execute
						;un-initialized (no program) memory.


;**************************** Subroutine Section ***************************************
Reverse:
				;function: reverses the elements in a vector
				;inputs: vector length & vector start address
				;input passing method: inputs are pulled (popped) from the stack
				;output: vector (memory) is modified
				;Special Note: all subroutines should be placed before or after the
				;main program.
		NOP		;these NOPs were put in to purge the pipeline so that SP would stablize
		NOP		;and stack memory would be constant by the time the last NOP is executed.
		NOP
		NOP
		NOP

		POP		AR7		;get the return address (high word) off the stack
		POP		AR6		;get the return address (low word) off the stack

		POP		AR0		;get the vector address
		POP		AL		;get the vector length

		MOV		AH,AR0		;set up a pointer to the last element addr
		ADD		AH,AL
		DEC		AH
		MOV		AR1,AH		;AR0 = first element addr, AR1 = last element addr

		LSR		AL,1		;divide the length by 2 & save in memory, this is the
						;loop counter

LOOP2:	MOV		AH,*AR0			;get first value
		MOV		AR2,AH		;temp storage
		MOV		AH,*AR1		;get last value
		MOV		*AR0,AH		;move last value to first position
		MOV		AH,AR2		;retrieve first value
		MOV		*AR1,AH		;move first value to last position
		INC		AR0		;inc ptr pointing to beginning of vector
		DEC		AR1		;dec prt pointing to end of vector
		DEC		AL		;dec counter and test if zero, if != 0 then repeat
		B		LOOP2,NEQ


		PUSH	AR6			;push return addr low word back onto stack (400 Hex)
		PUSH	AR7			;push return addr high word back onto stack (401 Hex)
		LRET				;end of subroutine, this instruction pops off the two word return addr

;******* Notes for Stepping through this Code ******
;  	1. 	Watch the SP register before/after a Push, Pop, Long Call (LC) and Long Return (LRET)
;	2. 	Observe how the stack memory changes (0x400 thru 0x403 internal SRAM) after a Push and/or LC.
;	3. 	Try to predict the SP changes and stack memory changes once you understand the
;		SP and stack operation.
;
; Special Note: Pipelining can cause the SP to change (inc or dec) a couple instructions earlier than expected.	To turn off the
; effects of pipelining (i.e. flush the pipeline every time an instruction is stepped), make sure the following is checked:
;
;	1. 	After building your project, make sure your project is highlighted on the left and then start the debugger .
;	2. 	Chose Target in the top tab and select Debug at the bottom of the pull-down window.
;	3. 	The Debug  properties (create, manage and run configurations) window should now open.
;	4.	Select the Target tab and scroll down to the bottom of the window to find the checkbox, labeled
;		"Simulators will flush the pipeline on a halt".  Make sure this is checked.   This will allow you to step code
;  		without the effects of the pipeline operation.  Note that in real-time DSP operation, the pipeline can not be
;		turned off.



