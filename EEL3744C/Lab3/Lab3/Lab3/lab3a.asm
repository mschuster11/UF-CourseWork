; Lab 3 part A
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  Uses a timer to enable PWM
;				on the blue LED of the RGB LED.

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;

; ~~~ Used in USE32MHzCLK ~~~ ;
.def clkPrescaler = r17           ; Denotes the input for the USE32MHzCLK input. Will hold the prescaler value.
.equ CLKEN = 0b0010               ; Enables the 32Mhz CLK.
.equ IOREG = 0xD8                 ; The value that sets the CPU_CCP reg to 'IOREG' mode.
.equ CLKPS = 0b00000000           ; Value that sets Prescaler A to 4. 
.equ CLKSEL = 1                   ; Value to select the 32MHz CLK.
.equ CLKOUT = 0b00000001          ; Value to output the CLK signal to port C.

; ~~~ Used in SETTIMER_PWM ~~~ ;
.equ TCDSEL = 0b0001               ; Value to set the prescaler of the TC to be 1024 time the period of the system CLK.
.equ TCDPER = 0x00FF               ; Value of the TC period.
.equ RGBVAL = 0x0F      
.equ TCDCMP = (0xFF - RGBVAL)
.equ TCDCMPAINT = 0b00010000       ; Value to init the TC compare A reg.
.equ TCDCMPA_INTFLAGLOC = 6        ; Location of the compare interrupt flag in the TC's interrupt flags reg.
.equ TCD_ENPORTD_SINGLESLOPE = 0b01000011	; Sets the PWM mode of the TC to single slope.


; ~~~ Used in MAIN ~~~ ;
.equ PDDIRSET = 0b01000000			; Value to set the dir of port D.
.equ REMAPTOBLUE = 0b00000100		; Value to remap the output of the TC handling the PWM.

.org 0x0000
    rjmp init                     ; Start at 0x0000 and jump to program.

.org 0x200
init:
	sei
    ldi clkPrescaler, CLKPS			; Load the prescaler value and call USE32MHzCLK.
    rcall USE32MHzCLK             
	rcall SETTIMER_PWM				; Init the PWM TC.
	ldi r16, PDDIRSET				; Set the direction of the blue RGB LED to output.
	sts PORTD_DIRTGL, r16
	ldi r16, REMAPTOBLUE			; Remap the TC's compare C from bit 2 to bit 6.
	sts PORTD_REMAP, r16
	ldi r16, 0xFF					; Init the RGB LED to off.
	sts PORTD_OUT, r16
loop:
	rjmp loop


.org 0x300
;*********************SUBROUTINES**************************************
; Subroutine Name: USE32MHzCLK
; Sets the external 32MHz as the active clock for the device
; Inputs: r17 as the desired prescaler for the clock
; Outputs: None
; Affected: r16, r17
USE32MHzCLK:
    push r16                      ; Preserve the values of r16, r17.
    push r17                      ;
    ldi r16, CLKEN                ; Load the CLK enable value and store it in the CLK control.
    sts OSC_CTRL, r16             ;

checkReady:                       
    lds r16, OSC_STATUS           ; This section pulls the oscillator status reg and constantly 
    andi r16, CLKEN               ; checks if the 32Mhz CLK is ready yet. 
    cpi r16, CLKEN                ;
    breq clockSel                 ; If it is move on, if not loop continuously.
    rjmp checkReady               ;
                        
clockSel:                       
    ldi r16, IOREG                ; Write 'IOREG' to the CPU_CCP to allow the CLK Prescaler
    sts CPU_CCP, r16              ; to be written to.
    sts CLK_PSCTRL, clkPrescaler  ;
    sts CPU_CCP, r16              ; Write 'IOREG' to the CPU_CCP to allow the CLK Control
    ldi r16, CLKSEL               ; to be set to output the 32 MHz.
    sts CLK_CTRL, r16             ;
    pop r17                       ; Restore the values of r16 and r17.
    pop r16                       ;
    ret                           ; return.

.org 0x350
;*********************SUBROUTINES**************************************
; Subroutine Name: SETTIMER_PWM
; Initialized TCC2 by setting its period and compare A value.
; Inputs: None
; Outputs: None
; Affected: r16,
SETTIMER_PWM:
    push r16						; Preserve r16.
    ldi r16, TCDSEL					; Enable the TC and set its period to be that of the system CLK.
    sts TCD0_CTRLA, r16				
	ldi r16, TCD_ENPORTD_SINGLESLOPE;
	sts TCD0_CTRLB, r16
    ldi r16, low(TCDPER)			; Load the period of the TC into the TC's period regs and load the same 
    sts TCD0_PER, r16            
    ldi r16, high(TCDPER)			 
	sts TCD0_PER+1, r16            
	ldi r16, low(TCDCMP)			; Load the value to be compared that will
	sts TCD0_CCC, r16				; determine the duty cycle.
	ldi r16, high(TCDCMP)
	sts TCD0_CCC+1, r16 
    pop r16							; Restore r16.
    ret								; Return.
