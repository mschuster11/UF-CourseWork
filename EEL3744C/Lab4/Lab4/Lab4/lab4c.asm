; Lab 4 part C
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  Output UART to monitoring.

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

; ~~~ Used in USART_INIT ~~~ ;
.equ CRTLB_INIT = 0b00011000		; En TX & RX, STD CLK, Non-MPCM, Non-9 bit data.
.equ CRTLC_INIT = 0b00110011		; Async, Odd parity, 1 stop bit, 8 data bits.
.equ BSEL_VAL = 1041					; 1047
.equ BSCALE_VAL = 0b1000			; -6 2's comp
.equ USART_BAUDCA_VAL = low(BSEL_VAL)								; Value to init the USART BUADA reg.
.equ USART_BAUDCB_VAL = (high(BSEL_VAL)>>4) | (BSCALE_VAL << 4)		; Value to init the USART BUADB reg.



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
	rcall USART_INIT				; Init USART on port D.
	ldi r17, 'U'					; Load the USART char to be outputted.

main:
	rcall OUT_CHAR					; Output a char.
	rjmp main						; Endlessly loop.


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

;*********************SUBROUTINES**************************************
; Subroutine Name: USART_INIT
; Initializes the UART interface
; Inputs: None
; Outputs: None
; Affected: r16
USART_INIT:
	push r16						; Preserve the values of r16.
	ldi r16, USART_TXEN_bm			; Set the direction of the TX and RX pins.
	sts PORTC_DIRSET, r16			
	ldi r16, USART_RXEN_bm
	sts PORTC_DIRCLR, r16
	ldi r16, USART_BAUDCA_VAL		; Set the BAUD rate.
	sts USARTC0_BAUDCTRLA, r16
	ldi r16, USART_BAUDCB_VAL
	sts USARTC0_BAUDCTRLB, r16
	ldi r16, CRTLC_INIT				; Set the USART mode and config.
	sts USARTC0_CTRLC, r16
	ldi r16, CRTLB_INIT				; Enable the pins.
	sts USARTC0_CTRLB, r16
	pop r16							; Restore r16.
	ret 							; return.

;*********************SUBROUTINES**************************************
; Subroutine Name: OUT_CHAR
; Send the character stored in r17 over UART
; Inputs: r17 - Character input 
; Outputs: None
; Affected: r16, r17
OUT_CHAR:
	push r16						; Preserve the values of r16, r17.
checkDre:
	lds r16, USARTC0_STATUS			; Pull the TX status flag and wait 
	sbrs r16, 5						; until it is ready to transmit again.
	rjmp checkDre
	sts USARTC0_DATA, r17
checkTx:
	lds r16, USARTC0_STATUS			; Pull the TX status flag and wait 
	sbrs r16, 6						; until it is ready to transmit again.
	rjmp checkTx
	pop r16							; Restore r16.
	ret 							; return.
