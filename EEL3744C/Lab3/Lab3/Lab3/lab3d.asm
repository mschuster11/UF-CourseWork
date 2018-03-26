; Lab 3 part D
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  Sets up an interrupt triggered by button S1 
;				that increments the value outputted to the LEDs
;				except with debouncing for S1.

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;
; ~~~		General		  ~~~ ;
.equ STACKINIT = 0x3FFF

; ~~~ Used in USE32MHzCLK ~~~ ;
.def clkPrescaler = r17				; Denotes the input for the USE32MHzCLK input. Will hold the prescaler value.
.equ CLKEN = 0b0010					; Enables the 32Mhz CLK.
.equ IOREG = 0xD8					; The value that sets the CPU_CCP reg to 'IOREG' mode.
.equ CLKPS = 0b00000000				; Value that sets Prescaler A to 4. 
.equ CLKSEL = 1						; Value to select the 32MHz CLK.
.equ CLKOUT = 0b00000001			; Value to output the CLK signal to port C.

; ~~~ Used in SETTIMER_PWM ~~~ ;
.equ TCDSEL = 0b0001				; Value to set the prescaler of the TC to be 1024 time the period of the system CLK.
.equ TCDPER = 0x00FF				; Value of the TC period.
.equ RGBVAL = 0x0F      
.equ TCDCMP = (TCDPER - RGBVAL)
.equ TCDCMPAINT = 0b00010000		; Value to init the TC compare A reg.
.equ TCDCMPA_INTFLAGLOC = 6			; Location of the compare interrupt flag in the TC's interrupt flags reg.
.equ TCD_ENPORTD_SINGLESLOPE = 0b01000011 ; Sets the PWM mode of the TC to single slope.
.equ REMAPTOBLUE = 0b00000100		; Remaps the TC's 3rd compare reg from the 2nd bit to the 6th bit. 

; ~~~ Used in DEBOUNCE_S1 ~~~ ;
.equ TCC0SEL = 0b0111				; Set the counter to 1024 times the sys CLK's period.
.equ TCC0PER = 0x0080				; Delay 0x40 ticks for debouncing.
.equ TCC0DISABLE = 0b0000			; Value to disable the TC.

; ~~~ Used in INIT_BUTTON_S1_INT ~~~ ; 
.equ INT0_LOW_EN = 0b0001			; Set the interrupt�s priority to low.
.equ BUTTON_S1_INT_TRIGG = 0b0100	; Set the interrupt to be triggered by S1.
.equ CLEAR_INT0_FLAG = 0b01			; Value to clear the interrupt�s flag.

; ~~~ Used in MAIN ~~~ ;
.equ S1_DIR_CLR = 0b0100			; Value to set the direction of S1 to input.
.equ RGB_BLUE_DIR_SET = 0b01000000	; Value to set the direction of the blue RGB LED to output.
.equ LEDS_DIR_OUT = 0xFF			; Value to set the direction of the backpack LEDs to output.
.equ LED_COUNT_INIT = 0xFF			; Initial value of the count.

.org 0x0000
    rjmp init						; Start at 0x0000 and jump to program.

.org 0x200
init:
	ldi clkPrescaler, CLKPS			; Standard inits of the CLK and stack ptr.
	rcall USE32MHzCLK
	ldi XL, low(STACKINIT)
	out CPU_SPL, XL
	ldi XL, high(STACKINIT)
	out CPU_SPH, XL
	ldi r16, S1_DIR_CLR				; Set S1 as input.
	sts PORTF_DIRCLR, r16
	ldi r16, RGB_BLUE_DIR_SET		; Set the blue RGB LED as output.
	sts PORTD_DIRSET, r16
	ldi r16, LEDS_DIR_OUT			; Set the backpack LEDs as output, and 
	sts PORTC_DIRSET, r16			; init their value to off.
	sts PORTC_OUT, r16
	rcall INIT_BUTTON_S1_INT		; Init S1's interrupt.
	sei								; Enable interrupts.
	ldi r17, LED_COUNT_INIT			; Set the LED count to zero. For active low 
									; LEDs this would be NOT 0x00 or 0xFF.	
loop:
	sts PORTD_OUTTGL, r16			; Toggle backpack LEDs and loop infinitely.
	rjmp loop

;*********************INTERUPT**************************************
; Subroutine Name: ISR_BUTTON_PRESSED
; Sets up an interupt to be triggered by the S1 button to 
; increment a count and output it to the LEDs.
; Inputs: None
; Outputs: None
; Affected: r16, r17
.org PORTF_INT0_vect
 rjmp ISR_BUTTON_PRESSED

 .org 0x300
ISR_BUTTON_PRESSED:					
	rcall DEBOUNCE_S1				; Handle the bouncing of the button by waiting.
	push r16						; Preserve r16.
	lds r16, PORTF_IN				; Check the switch to make sure it's still
	sbrc r16, 2						; being pressed.
	rjmp endInt						; If not, exit the ISR.
	dec r17							; If so, decrement r17 which is equivalent to
	sts PORTC_OUT, r17				; incrementing the count displayed by the LEDs
									; as they are active low.
endInt:
	ldi r16, CLEAR_INT0_FLAG		; Clear the interrupt flag.
	sts PORTF_INTFLAGS, r16
	pop r16							; Restore r16.
	reti							; Return.


;*********************SUBROUTINES**************************************
; Subroutine Name: USE32MHzCLK
; Sets the external 32MHz as the active clock for the device
; Inputs: r17 as the desired prescaler for the clock
; Outputs: None
; Affected: r16, r17
USE32MHzCLK:
    push r16						; Preserve the values of r16, r17.
    push r17						
    ldi r16, CLKEN					; Load the CLK enable value and store it in the CLK control.
    sts OSC_CTRL, r16				

checkReady:                       
    lds r16, OSC_STATUS				; This section pulls the oscillator status reg and constantly 
    andi r16, CLKEN					; checks if the 32Mhz CLK is ready yet. 
    cpi r16, CLKEN                
    breq clockSel					; If it is move on, if not loop continuously.
    rjmp checkReady               
                        
clockSel:                       
    ldi r16, IOREG					; Write 'IOREG' to the CPU_CCP to allow the CLK Prescaler
    sts CPU_CCP, r16				; to be written to.
    sts CLK_PSCTRL, clkPrescaler  
    sts CPU_CCP, r16				; Write 'IOREG' to the CPU_CCP to allow the CLK Control
    ldi r16, CLKSEL					; to be set to output the 32 MHz.
    sts CLK_CTRL, r16             
    pop r17							; Restore the values of r16 and r17.
    pop r16                       
    ret								; return.



;*********************SUBROUTINES**************************************
; Subroutine Name: SETTIMER_PWM
; Initialized TCD0 by setting its period and compare A value.
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


;*********************SUBROUTINES**************************************
; Subroutine Name: INIT_BUTTON_S1_INT
; Set up an interupt for button S1.
; Inputs: None
; Outputs: None
; Affected: r16,
INIT_BUTTON_S1_INT:
	push r16						; Preserve r16.
	ldi r16, INT0_LOW_EN			; Set the interrupt�s priority
	sts PORTF_INTCTRL, r16			; to low.
	ldi r16, BUTTON_S1_INT_TRIGG	; Set the bitmask to trigger the 
	sts PORTF_INT0MASK, r16			; interrupt on S1's bit.
	ldi r16, PORT_ISC_FALLING_gc	; Set the interrupt to trigger on
	sts PORTF_PIN2CTRL, r16			; a falling edge as S1 is active low.
	ldi r16, PMIC_LOLVLEN_bm		; Enable low priority interrupts.
	sts PMIC_CTRL, r16
	pop r16							; Restore r16.
	ret								; Return.


;*********************SUBROUTINES**************************************
; Subroutine Name: DEBOUNCE_S1
; Checks for bouncing on S1.
; Inputs: None
; Outputs: None
; Affected: r16
DEBOUNCE_S1:
    push r16						; Preserve r16.
    ldi r16, TCC0SEL                ; Enable the TC and set its period to be 1024 times that of the system CLK.
    sts TCC0_CTRLA, r16				
    ldi r16, low(TCC0PER)           ; Load the period of the TC into the TC's period regs.
    sts TCC0_PER, r16            
    ldi r16, high(TCC0PER)          ;
	sts TCC0_PER+1, r16            
checkS1Loop:
	lds r16, TCC0_INTFLAGS			; Wait until the TC's overflow flag is triggered
	sbrs r16, 0
	rjmp checkS1Loop
	ldi r16, 0x01					; Once broken from the loop, clear the flag, reset the
	sts TCC0_INTFLAGS, r16			; count, and disable the timer.
	ldi r16, 0x00
	sts TCC0_CNT, r16
	ldi r16, TCC0DISABLE
	sts TCC0_CTRLA, r16
	pop r16							; Restore r16.
	ret								; Return.
