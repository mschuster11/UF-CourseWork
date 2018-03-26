; HW4
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  Comparing asm and compiled asm. 

.nolist                           	; Included for fun.
.include "ATxmega128A1Udef.inc"   	;
.list                             	;

; ~~~		General		  ~~~ ;
.equ STACKINIT = 0x3FFF				; Init val for the stack ptr.

; ~~~ Used in USE32MHzCLK ~~~ ;
.def clkPrescaler = r17           	; Denotes the input for the USE32MHzCLK input. Will hold the prescaler value.
.equ CLKEN = 0b0010               	; Enables the 32Mhz CLK.
.equ IOREG = 0xD8                 	; The value that sets the CPU_CCP reg to 'IOREG' mode.
.equ CLKPS = 0b00000000           	; Value that sets Prescaler A to 4. 
.equ CLKSEL = 1                   	; Value to select the 32MHz CLK.
.equ CLKOUT = 0b00000001          	; Value to output the CLK signal to port C.

.org 0x0000
    rjmp init						; Start at 0x0000 and jump to program.

.org 0x200
init:
	ldi clkPrescaler, CLKPS			; Standard inits of the CLK, the RGB, stack ptr.
	rcall USE32MHzCLK
	ldi XL, low(STACKINIT)			
	out CPU_SPL, XL
	ldi XL, high(STACKINIT)
	out CPU_SPH, XL
	ldi r16, 12
	ldi r17, 7
	rcall average
main:
	rjmp main



;*********************SUBROUTINES**************************************
; Subroutine Name: average
; Calculates the average of two numbers
; Inputs: r16, r17 - number inputs.
; Outputs: r16 - average
; Affected: r16, r17
average:
	add r16, r17
	lsr r16
	ret


;*********************SUBROUTINES**************************************
; Subroutine Name: USE32MHzCLK
; Sets the external 32MHz as the active clock for the device
; Inputs: r17 as the desired prescaler for the clock
; Outputs: None
; Affected: r16, r17
USE32MHzCLK:
    push r16                      	; Preserve the values of r16, r17.
    push r17                      	;
    ldi r16, CLKEN                	; Load the CLK enable value and store it in the CLK control.
    sts OSC_CTRL, r16             	;

checkReady:                       
    lds r16, OSC_STATUS           	; This section pulls the oscillator status reg and constantly 
    andi r16, CLKEN               	; checks if the 32Mhz CLK is ready yet. 
    cpi r16, CLKEN                	;
    breq clockSel                 	; If it is move on, if not loop continuously.
    rjmp checkReady               	;
                        
clockSel:                       
    ldi r16, IOREG                	; Write 'IOREG' to the CPU_CCP to allow the CLK Prescaler
    sts CPU_CCP, r16              	; to be written to.
    sts CLK_PSCTRL, clkPrescaler  	;
    sts CPU_CCP, r16              	; Write 'IOREG' to the CPU_CCP to allow the CLK Control
    ldi r16, CLKSEL               	; to be set to output the 32 MHz.
    sts CLK_CTRL, r16             	;
    pop r17                       	; Restore the values of r16 and r17.
    pop r16                       	;
    ret                           	; return.