; Lab 3 quiz
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  Playing PONG using S1

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;
; ~~~		General		  ~~~ ;
.equ STACKINIT = 0x3FFF

; ~~~ Used in USE32MHzCLK ~~~ ;
.def clkPrescaler = r17           ; Denotes the input for the USE32MHzCLK input. Will hold the prescaler value.
.equ CLKEN = 0b0010               ; Enables the 32Mhz CLK.
.equ IOREG = 0xD8                 ; The value that sets the CPU_CCP reg to 'IOREG' mode.
.equ CLKPS = 0b00000000           ; Value that sets Prescaler A to 4. 
.equ CLKSEL = 1                   ; Value to select the 32MHz CLK.
.equ CLKOUT = 0b00000001          ; Value to output the CLK signal to port C.

; ~~~ Used in INIT_RGB ~~~ ;
.equ RGB_DIRSET = 0b01110000

; ~~~ Used in SETTIMER_PWM ~~~ ;
.equ TCDSEL = 0b0001				; Value to set the prescaler of the TC to be 1024 time the period of the system CLK.
.equ TCDPER = 0x00FF				; Value of the TC period.  
.equ TCDCMPAINT = 0b00010000		; Value to init the TC compare A reg.
.equ TCDCMPA_INTFLAGLOC = 6			; Location of the compare interrupt flag in the TC's interrupt flags reg.
.equ TCD_ENPORTD_SINGLESLOPE = 0b01110011	; Sets the PWM mode of the TC to single slope.
.equ RGB_REMAP = 0b00000111			; Value to remap pins 0, 1, & 2 to 4, 5, & 6 respectively.

; ~~~ Used in DELAY_100ms ~~~ ;
.equ TC_SEL = 0b0111				; Value to set the prescaler of the TC to be 1024 time the period of the system CLK.
.equ TC_PER = 0x0C35				; Value of the TC period.  
.equ TC_DISABLE = 0b0000

; ~~~ Used in DEBOUNCE_S1 ~~~ ;
.equ TCC0SEL = 0b0111				; Set the counter to 1024 times the sys CLK's period.
.equ TCC0PER = 0x0080				; Delay 0x80 ticks for debouncing.
.equ TCC0DISABLE = 0b0000			; Value to disable the TC.

; ~~~ Used in INIT_BUTTON_S1_INT ~~~ ; 
.equ INT0_LOW_EN = 0b0001			; Set the interrupt’s priority to low.
.equ BUTTON_S1_INT_TRIGG = 0b0100	; Set the interrupt to be triggered by S1.
.equ CLEAR_INT0_FLAG = 0b01			; Value to clear the interrupt’s flag.

; ~~~ Used in ISR_BUTTON_PRESSED ~~~ ; 
.equ NUM_STATES = 4					; Number of states in the state machine.

; ~~~ Used in MAIN ~~~ ;
.equ S1_DIR_CLR = 0b1100			; Value to set the direction of S1 to input.
.equ INIT_STATE = 0x00				; Initial state of the state machine.
.equ GAME_STATE = 0x01
.equ GAME1_STATE = 0x00
.equ GAME2_STATE = 0x01
.equ END_STATE = 0x02
.equ OFF_STATE = 0x00				; State for setting the RGB to off.
.equ UF_STATE = 0x01				; State for setting the RGB to UF colors.
.equ CHRISTMAS_STATE = 0x02			; State for setting the RGB to Christmas colors.
.equ HULK_STATE = 0x03				; State for setting the RGB to Hulk colors.
.equ COPS_STATE = 0x04				; State for setting the RGB to police colors.
.equ RGB_OFF_VAL = 0x000000			; RGB Value for off.
.equ RGB_UF_ORNG = 0xFA4616			; RGB Value for UF orange.
.equ RGB_UF_BLUE = 0x0021A5			; RGB Value for UF blue.
.equ RGB_CHRISTMAS_RED = 0xC21F1F	; RGB Value for Christmas red.
.equ RGB_CHRISTMAS_GRN = 0x3C8D0D	; RGB Value for Christmas green.
.equ RGB_HULK_PRPL = 0x8A2C9A		; RGB Value for Hulk purple.
.equ RGB_HULK_GRN = 0x49FF07		; RGB Value for Hulk green.
.equ RGB_COPS_BLUE = 0x000080		; RGB Value for police blue.
.equ RGB_COPS_RED = 0x720027		; RGB Value for police red.
.equ RGB_RED = 0xFF0000




.org 0x0000
    rjmp main						; Start at 0x0000 and jump to program.

.org 0x200
main:
	ldi clkPrescaler, CLKPS			; Standard inits of the CLK, the RGB, stack ptr.
	rcall USE32MHzCLK
	rcall INIT_RGB
	ldi XL, low(STACKINIT)
	out CPU_SPL, XL
	ldi XL, high(STACKINIT)
	out CPU_SPH, XL
	ldi r16, S1_DIR_CLR				; Set the direction of S1's direction to input.
	sts PORTF_DIRCLR, r16
	rcall INIT_BUTTON_S1_INT		; Setup the interrupt for S1 being pressed.
	sei								; Enable interrupts
	ldi r16, 0xFF
	sts PORTC_DIRSET, r16
	sts PORTC_OUT, r16
	ldi r19, INIT_STATE				; Set the initial state. 

loop:
	cpi r19, INIT_STATE				; Case statement to handle state machine.
	breq INIT
	cpi r19, GAME_STATE
	breq GAME
	cpi r19, END_STATE
	breq END
;	cpi r19, HULK_STATE
;	breq RGB_HULK
;	cpi r19, COPS_STATE
;	breq RGB_COPS
	rjmp loop						; Catch just in case.

GAME:
	rcall SET_RGB_OFF
	sbrs r21, 0
	rjmp GAME1
	rjmp GAME2

INIT:
	rcall SET_RGB_OFF				; Turn of RGB.
	ldi r16, 0xFF
	sts PORTC_OUT, r16
	rjmp loop

GAME1:
	lds r16, PORTC_OUT
	sts CPU_SREG, r20
	rol r16
	lds r20, CPU_SREG
	sei
	sts PORTC_OUT, r16
	rcall DELAY_100ms
	rcall DELAY_100ms
	cpi r16, 0x7F
	brne game1End
	inc r21
game1End:
	rjmp loop

GAME2:
	lds r16, PORTC_OUT
	sts CPU_SREG, r20
	ror r16
	lds r20, CPU_SREG
	sei
	sts PORTC_OUT, r16
	rcall DELAY_100ms
	rcall DELAY_100ms
	cpi r16, 0xFE
	brne game2End
	sbrs r22, 0
	rjmp lost
	
	dec r21
game2End:
	ldi r22, 0
	rjmp loop

lost:
	ldi r22, 0
	ldi r21, 0
	ldi r19, END_STATE
	ldi r16, 0xFF
	sts PORTC_OUT, r16
	rjmp loop

END:
	ldi r16, ~byte3(RGB_RED) ; Oscillate between Christmas colors, waiting 1ms on each.
	ldi r17, ~byte2(RGB_RED)
	ldi r18, ~byte1(RGB_RED)
	rcall SET_RGB
	lds r16, PORTF_IN
	sbrc r16, 3
	rjmp loop
	ldi r16, 0xFE
	sts PORTC_OUT, r16
	ldi r19, GAME_STATE
	ldi r21, 0x00
	rcall SET_RGB_OFF
	rcall DELAY_100ms
	rcall DELAY_100ms
;	rcall DELAY_100ms
;	ldi r16, ~byte3(RGB_CHRISTMAS_GRN)
;	ldi r17, ~byte2(RGB_CHRISTMAS_GRN)
;	ldi r18, ~byte1(RGB_CHRISTMAS_GRN)
;	rcall SET_RGB
;	rcall DELAY_100ms
	rjmp loop

;RGB_HULK:
;	ldi r16, ~byte3(RGB_HULK_PRPL) ; Oscillate between Hulk colors, waiting 1ms on each.
;	ldi r17, ~byte2(RGB_HULK_PRPL)
;	ldi r18, ~byte1(RGB_HULK_PRPL)
;	rcall SET_RGB
;	rcall DELAY_100ms
;	ldi r16, ~byte3(RGB_HULK_GRN)
;	ldi r17, ~byte2(RGB_HULK_GRN)
;	ldi r18, ~byte1(RGB_HULK_GRN)
;	rcall SET_RGB
;	rcall DELAY_100ms
;	rjmp loop

; Included for fun!
;RGB_COPS:
;	ldi r16, ~byte3(RGB_COPS_BLUE); Oscillate between cop colors, waiting 1ms on each.
;	ldi r17, ~byte2(RGB_COPS_BLUE) 
;	ldi r18, ~byte1(RGB_COPS_BLUE)
;	rcall SET_RGB
;	rcall DELAY_100ms
;	ldi r16, ~byte3(RGB_COPS_RED)
;	ldi r17, ~byte2(RGB_COPS_RED)
;	ldi r18, ~byte1(RGB_COPS_RED)
;	rcall SET_RGB
;	rcall DELAY_100ms
;	rjmp loop


	

;*********************INTERUPT**************************************
; Subroutine Name: ISR_BUTTON_PRESSED
; Sets up an interrupt to be triggered by the S1 button to 
; increment a count and output it to the LEDs.
; Inputs: None
; Outputs: None
; Affected: r16, r17
.org PORTF_INT0_vect
 rjmp ISR_BUTTON_PRESSED

 .org 0x300
ISR_BUTTON_PRESSED:
	rcall DEBOUNCE_S1				; Handle debouncing by waiting.
	push r16						; Preserve r16.
	lds r16, PORTF_IN				; Check if S1 is still being pressed.
	sbrc r16, 2
	rjmp endInt						; If not, exit the ISR.
	cpi r19, INIT_STATE
	brne checkGame
	inc r19
	ldi r16, 0xFE
	sts PORTC_OUT, r16
	rjmp endInt

checkGame:
	cpi r19, GAME_STATE
	brne checkEnd

checkG1:
	ldi r22, 1
	cpi r21, GAME1_STATE
	brne checkG2
	lds r16, PORTC_OUT
	cpi r16, 0xFE
	brne loser

checkG2:
	ldi r22, 1
	cpi r21, GAME2_STATE
	brne checkEnd
	lds r16, PORTC_OUT
	cpi r16, 0xFE
	brne loser

checkEnd:
	cpi r19, END_STATE
	brne endInt

	rjmp endInt

loser:
	ldi r22, 0
	ldi r19, END_STATE
	ldi r16, 0xFF
	sts PORTC_OUT, r16
	rjmp endInt


endInt:
	ldi r16, CLEAR_INT0_FLAG		; If so, clear the inter
	sts PORTF_INTFLAGS, r16
	pop r16
	reti


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
	ldi r16, TCD_ENPORTD_SINGLESLOPE; Set the TC's PWM mode to "single slope".
	sts TCD0_CTRLB, r16
    ldi r16, low(TCDPER)			; Load the period of the TC into the TC's period regs.
    sts TCD0_PER, r16            
    ldi r16, high(TCDPER)	
	sts TCD0_PER+1, r16            
    pop r16							; Restore r16.
    ret								; Return.


;*********************SUBROUTINES**************************************
; Subroutine Name: DELAY_100ms
; Delays 1ms
; Inputs: None
; Outputs: None
; Affected: r16
DELAY_100ms:
	push r16						; Preserve r16.
    ldi r16, TC_SEL					; Enable the TC and set its period to be that of the system CLK.
    sts TCC1_CTRLA, r16           
    ldi r16, low(TC_PER)			; Load the period of the TC into the TC's period regs.
    sts TCC1_PER, r16            
    ldi r16, high(TC_PER)           
	sts TCC1_PER+1, r16
DELAY_100ms_loop:						; Loop checking the TC's interrupt flags until 
	lds r16, TCC1_INTFLAGS			; the overflow flag is set.
	sbrs r16, 0
	rjmp DELAY_100ms_loop
	sts TCC1_INTFLAGS, r16
	ldi r16, TC_DISABLE				; Break from the loop and disable the TC.
	sts TCC1_CTRLA, r16           
	pop r16							; Restore r16.
	ret								; Return.


;*********************SUBROUTINES**************************************
; Subroutine Name: INIT_RGB
; Sets up the RGB LED
; Inputs: None
; Outputs: None
; Affected: r16
INIT_RGB:
	rcall SETTIMER_PWM				; Set the TC used to operate on the RGB.
	push r16						; Preserve r16.
	ldi r16, RGB_DIRSET				; Set port D (RGB port) to output.
	sts PORTD_DIRSET, r16
	ldi r16, RGB_REMAP				; Remap bits 6-4 to TCD0's compare regs A, B, and C.
	sts PORTD_REMAP, r16
	pop r16							; Restore r16.
	ret								; Return.

;*********************SUBROUTINES**************************************
; Subroutine Name: SET_RGB
; Sets the value of the RGB LED
; Inputs: r16: Value of Red, r17: Value of Green, r18: Value of Blue
; Outputs: None
; Affected: r16, r17, r18
SET_RGB:
	push r16						; Preserve r16.
	sts TCD0_CCA, r16				; Set each of the compare regs to 
	ldi r16, 0x00					; their respective RGB values.
	sts TCD0_CCA+1, r16 
	sts TCD0_CCB, r17           
	sts TCD0_CCB+1, r16
	sts TCD0_CCC, r18           
	sts TCD0_CCC+1, r16
	pop r16							; Restore r16.
	ret								; Return.


;*********************SUBROUTINES**************************************
; Subroutine Name: SET_RGB_OFF
; Turns the RGB off.
; Inputs: None
; Outputs: None
; Affected: r16
SET_RGB_OFF:
	push r16						; Preserve r16.
	ldi r16, 0xFF					; Set r16 to a value outside
	sts TCD0_CCA, r16				; the TC's period.
	sts TCD0_CCA+1, r16 
	sts TCD0_CCB, r16				; This prevents the RGB from
	sts TCD0_CCB+1, r16				; ever being on.
	sts TCD0_CCC, r16           
	sts TCD0_CCC+1, r16
	pop r16							; Restore r16.
	ret								; Return.


;*********************SUBROUTINES**************************************
; Subroutine Name: INIT_BUTTON_S1_INT
; Set up an interrupt for button S1.
; Inputs: None
; Outputs: None
; Affected: r16,
INIT_BUTTON_S1_INT:
	push r16						; Preserve r16.
	ldi r16, INT0_LOW_EN			; Set the interrupt’s priority
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
