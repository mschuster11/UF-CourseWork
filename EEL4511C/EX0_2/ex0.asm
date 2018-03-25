;****************************************************************************************
; file = ex0.asm
; Quick examples of Assembler directives & 28F335 DSP code
; Dr. Karl Gugel, May/2009
;
; To be assembled using Code Composer Studio which requires a linker command 
; file to tell CCR where to place code & data into DSP SRAM. 
; The command file used = 28335_RAM_lnk.com
; Important Code locations:
;		.text	RAML1   (internal DSP memory) starting address = 09000 Hex, 4K Words
;		.data   RAML2	(internal DSP memory) starting address = 0A000 Hex, 4K Words 		
;
; Special Note:  
;		Assembler directives are used to place data and variables into memory.  
;		They are not F335 instructions and thus are not executed at "run-time".  
;		When this program is loaded into memory, the data (created above by the 
;		assembler) is also copied down into memory. This is called "load-time".
;
		.global		_c_int00	;This assembler directive allows _c_int00 to be a
								;global variable. This tells the linker where your
								;program (.text code) begins and where to boot from. 
;								
; Additional References:
; 						Assembler Directives: spru513c.pdf
;						Memory Map/Hardware Related: sprs439e.pdf (also called 320f28335.pdf)
;						CPU Registers & Assembly Code: spru430.pdf (version E)	
;****************************************************************************************

;***************************** Program Constants ****************************************
; Creating constants using the .set assembler directive. This should be at the top of your
; program.  This is like a define statement in C.
num1		.set		0h				;assembly-time constant (hex number) 
num2		.set		11110000b		;assembly-time constant (binary no.)
num3		.set		65535			;assembly-time constant (decimal no.)
count		.set		3				;number of characters to add in EEL4744 ('E'+'E'+'L')
data_sect	.set		0xa000			;constant that is actually the starting addr of .data section
bss_sect	.set		0xb000			;constant that is actually the starting addr of .bss section
;****************************************************************************************

;******************* DATA ALLOCATION SECTION - Variables/Data ***************************
; Data can go before or after your program code but should not be placed in the middle
; nof a program for clarity reasons.
		.data				;data section, see the command linker file, this puts the 
							;following data defined below in a block of internal SRAM
							;starting at 0xA000. 
counter .word    	0h  	;define word, two bytes placed in memory stating in the data section     
num4    .word    	01234h	;define word, two bytes placed in memory
char    .byte    	'E' 	;define string, ASCII characters placed in memory as WORDS!
        .byte    	'E'
        .byte    	'L'
        .byte    	'4'
        .byte    	'7'
        .byte    	'4'
        .byte    	'4'
        .byte		"0123"	;here is another way to specify a string of WORDS!
	    .word		0xfab4	;another way to specify a hex number (WORD)
val1	.word		32		;places 32 decimal (20 hex) in memory (WORD) at label val1 at load-time
val2	.word		512		;places 512 decimal(200 hex) in memory (WORD) at label val2 at load-time
val3	.long		0x12345678	;places two words in memory (lower word/lower addr, big endian)	
	    		
	    					;.BSS SECTION is used to reserve space in SRAM for run-time results.
	    					; See the command linker file, the starting address is 0xB000
	    .bss		results,3	;reserves three words at label 'results' in the .bss section	
	    .bss		sum,1		;reserves one word at label 'sum' in the .bss section
	    
								;.global directive lets you to see the assigned addresses in map file.	    
		.global		num1,num2,num3,num3,num4,counter,char,val1,val2,val3,results,sum 
;****************************************************************************************

;******************** Brief Introduction to CPU Model ***********************************
; CPU Registers: 
;	ACC		Accumulator (32 bits) comprised of AH (upper 16 bits) and AL (lower 16 bits)
;	XAR0	Auxiliary Register0 (32 bits) comprised of AR0H (upper 16 bits) and AR0 (lower 16 bits) 
;	XAR1	Auxiliary Register1 (32 bits) comprised of AR1H (upper 16 bits) and AR1 (lower 16 bits) 
;	XAR2	Auxiliary Register2 (32 bits) comprised of AR2H (upper 16 bits) and AR2 (lower 16 bits) 
;	XAR3	Auxiliary Register3 (32 bits) comprised of AR3H (upper 16 bits) and AR3 (lower 16 bits) 
;	XAR4	Auxiliary Register4 (32 bits) comprised of AR4H (upper 16 bits) and AR4 (lower 16 bits) 
;	XAR5	Auxiliary Register5 (32 bits) comprised of AR5H (upper 16 bits) and AR5 (lower 16 bits) 
;	XAR6	Auxiliary Register6 (32 bits) comprised of AR6H (upper 16 bits) and AR6 (lower 16 bits) 
;	XAR7	Auxiliary Register7 (32 bits) comprised of AR7H (upper 16 bits) and AR6 (lower 16 bits) 	
;	XT		Multiplicand Register (32 bits) comprised of T (upper 16 bits) and TL (lower 16 bits)
;	P		Product Register (32 bits) comprised PH (upper 16 bits) and PL (lower 16 bits)
;	PC		Program Counter (22 bits) 
;	SP		Stack Pointer (16 bits) 
;	DP		Data Page Register (16 bits) 
;	ST1,ST0	Status Registers (flags)



;****************************************************************************************

;****************** F335 Program Examples ***********************
		.text			;Program section, see the command linker file, program code 
						;should be placed in the text section which starts at 0x9000
						
_c_int00:				;This label tells the linker where the entry (starting) point for 
						;the first instruction in your program.	

									;Short example1 to sum 1st three chars in string EEL4744. 
									;This illustrates immediate, indirect and register addr modes
		MOV		AR0,#char			;address of 1st char in EEL4744									
		MOV		AR1,#sum			;address of where final sum (result)will be stored
		MOV		AR2,#counter		;address of counter saved in memory
		MOV		AH,#count			;load the count value & save in memory counter 
		MOV		*AR2,AH				
		MOV		AL,#0				;clear initial sum
TOP1	ADD		AL,*AR0				;add char value to sum
		INC		AR0					;increment pointer used to get a char value
		DEC		*AR2				;decrement counter in memory
		B		TOP1,NEQ			;if the Z flag is 0, branch up and repeat adding
		MOV		*ar1,AL
		NOP							;No operation to view sum in memory at addr results
		NOP							;put some instructions (space) inbetween the next example
									;for stepping through with the debugger so no regs change.
;
									;Short example2 to illustrate direct addressing and
									;mathematical & shift operations.
		MOV		DP,#data_sect>>6	;set datapage pointer to point to .data section
		MOV		T,@val1				;load T using direct addressing mode
		MPYU	ACC,T,@val2			;val1[] * val2[] => ACC, 16 bit unsigned multiply

		MOV		DP,#bss_sect>>6		;set datapage pointer to point to .bss section	
		MOV		@results,AL			;save lower word only, which assumes answers is 16 bits or less

		MOV		DP,#data_sect>>6	;set datapage pointer back to .data section
		MOV		AL,@val1			;add val1[] + val2[]
		ADD		AL,@val2
		MOV		DP,#bss_sect>>6		;set datapage pointer to point to .bss section	
		MOV		@results+1,AL		;save val1[] + val2[]		

									;Shift left example
		MOV		AH,#num3			;set AH to a predetermined value to see if the 
									;next instruction affects AH
		LSL		AL,#5				;logical shift left AL by 5 places
		MOV		@results+2,AL

		NOP	
		NOP						
END1	B		END1,UNC			;infinite loop to just keep us from trying to execute
									;un-initialized (no program) memory. 

