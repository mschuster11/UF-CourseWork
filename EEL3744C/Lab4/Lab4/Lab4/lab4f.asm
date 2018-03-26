; Lab 4 part F
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  Using to UART to a menu and take input.

.nolist                           	; Included for fun.
.include "ATxmega128A1Udef.inc"   	;
.list                             	;

; ~~~		General		  ~~~ ;
.equ STACKINIT = 0x3FFF				; Init val fot eh stack ptr.

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
.equ BSEL_VAL = 107					; 107
.equ BSCALE_VAL = 0b1011			; -5 2's comp
.equ USART_BAUDCA_VAL = low(BSEL_VAL)								; Value to init the USART BUADA reg.
.equ USART_BAUDCB_VAL = (high(BSEL_VAL)>>4) | (BSCALE_VAL << 4)		; Value to init the USART BUADB reg.

; ~~~ Used in MAIN ~~~ ;
.equ STRING_ADDR = 0x200
.equ CR = 0x0D
.equ LF = 0x0A

.org 0x0000
    rjmp init						; Start at 0x0000 and jump to program.

.org STRING_ADDR
header:
	.db "Mark's favorite:", CR, LF, 0x00
food:
	.db "1. Food", CR, LF, 0x00
course:
	.db "2. UF Course", CR, LF, 0x00, 0x00
hobby:
	.db "3. Hobby", CR, LF, 0x00, 0x00
quote:
	.db "4. Quote", CR, LF, 0x00, 0x00
movie:
	.db "5. Movie", CR, LF, 0x00, 0x00
menu:
	.db "6. Re-display menu", CR, LF, 0x00, 0x00
done:
	.db "D: Done", CR, LF, 0x00

foodRsp:
	.db "Mark's favorite food is italian.", CR, LF, 0x00, 0x00
courseRsp:
	.db "Mark's favorite UF course is EEL3701.", CR, LF, 0x00
hobbyRsp:
	.db "Mark's favorite hobby is finance.", CR, LF, 0x00
quoteRsp:
	.db "Mark's favorite quote is ", '"', "The more you learn, the more you earn.", '"', " - Warren Buffet.", CR, LF, 0x00, 0x00
movieRsp:
	.db "Mark's favorite movie is The Pursuit of Happiness.", CR, LF, 0x00, 0x00
doneRsp:
	.db "Done!", CR, LF, 0x00

.org 0x400
init:
	ldi clkPrescaler, CLKPS			; Standard inits of the CLK, the RGB, stack ptr.
	rcall USE32MHzCLK
	ldi XL, low(STACKINIT)			
	out CPU_SPL, XL
	ldi XL, high(STACKINIT)
	out CPU_SPH, XL
	rcall USART_INIT				; Init USART on port D.
	ldi ZH, byte3(STRING_ADDR << 1)
	out CPU_RAMPZ, ZL
	ldi ZH, byte2(STRING_ADDR << 1)
	ldi ZL, byte1(STRING_ADDR << 1)
	rcall OUT_MENU 					; Output Menu

	
main:
	rcall IN_CHAR					; Take input
	cpi r17, '1'					; Switch statement for each case.
	breq choice1
	cpi r17, '2'
	breq choice2
	cpi r17, '3'
	breq choice3
	cpi r17, '4'
	breq choice4
	cpi r17, '5'
	breq choice5
	cpi r17, '6'
	breq choice6
	cpi r17, 'd'
	breq doneTerm
	cpi r17, 'D'
	breq doneTerm
	rjmp main						; Endlessly loop.

choice1:							; Output each response depending on the input.
	ldi ZH, high(foodRsp << 1)
	ldi ZL, low(foodRsp << 1)
	rcall OUT_STRING
	rjmp main
choice2:
	ldi ZH, high(courseRsp << 1)
	ldi ZL, low(courseRsp << 1)
	rcall OUT_STRING
	rjmp main
choice3:
	ldi ZH, high(hobbyRsp << 1)
	ldi ZL, low(hobbyRsp << 1)
	rcall OUT_STRING
	rjmp main
choice4:
	ldi ZH, high(quoteRsp << 1)
	ldi ZL, low(quoteRsp << 1)
	rcall OUT_STRING
	rjmp main
choice5:
	ldi ZH, high(movieRsp << 1)
	ldi ZL, low(movieRsp << 1)
	rcall OUT_STRING	
	rjmp main
choice6:
	rcall OUT_MENU
	rjmp main

doneTerm:
	ldi ZH, high(doneRsp << 1)			; If 'd' || 'D', print response and terminate.
	ldi ZL, low(doneRsp << 1)
	rcall OUT_STRING
end:
	rjmp end



	




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
	sts PORTD_DIRSET, r16			
	ldi r16, USART_RXEN_bm
	sts PORTD_DIRCLR, r16
	ldi r16, USART_BAUDCA_VAL		; Set the BAUD rate.
	sts USARTD0_BAUDCTRLA, r16
	ldi r16, USART_BAUDCB_VAL
	sts USARTD0_BAUDCTRLB, r16
	ldi r16, CRTLC_INIT				; Set the USART mode and config.
	sts USARTD0_CTRLC, r16
	ldi r16, CRTLB_INIT				; Enable the pins.
	sts USARTD0_CTRLB, r16
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
	lds r16, USARTD0_STATUS			; Pull the TX status flag and wait 
	sbrs r16, 5						; until it is ready to transmit again.
	rjmp checkDre
	sts USARTD0_DATA, r17
checkTx:
	lds r16, USARTD0_STATUS			; Pull the TX status flag and wait 
	sbrs r16, 6						; until it is ready to transmit again.
	rjmp checkTx
	pop r16							; Restore r16.
	ret 							; return.

;*********************SUBROUTINES**************************************
; Subroutine Name: IN_CHAR
; Send the character stored in r17 over UART
; Inputs: None 
; Outputs: r17 - The value of the char taken in.
; Affected: r16, r17
IN_CHAR: 
	push r16						; Preserve the value of r16.
checkRx:
	lds r16, USARTD0_STATUS			; Pull the data status flag and wait 
	sbrs r16, 7						; until it is ready to receive again.
	rjmp checkRx
	lds r17, USARTD0_DATA
	pop r16							; Restore r16.
	ret 							; return.

;*********************SUBROUTINES**************************************
; Subroutine Name: OUT_STRING
; Send the character stored in Z over UART
; Inputs: Z - String input 
; Outputs: None
; Affected: r16, Z
OUT_STRING:
	push r16						; Preserve r16 and the Z pointer.
    mov r16, ZL                    
    push r16                       
    mov r16, ZH                    
    push r16                       
    lds r16, CPU_RAMPZ             
    push r16
stringLoop:                       
	lpm r17, Z+
	cpi r17, 0x00
	breq stringRet
	rcall OUT_CHAR
	rjmp stringLoop
stringRet:
	pop r16							; Restore r16 and the Z pointer.
    mov ZL, r16						
    out CPU_RAMPZ, r16             
    pop r16                        
    mov ZH, r16                    
    pop r16                        
    mov ZL, r16                    
    pop r16                        
    ret								; Return.


	;*********************SUBROUTINES**************************************
; Subroutine Name: OUT_MENU
; Display the menu over UART
; Inputs: None 
; Outputs: None
; Affected: r16, Z
OUT_MENU:
	push r16						; Preserve r16 and the Z pointer.
    mov r16, ZL						; Load Z with the starting value of
    push r16						; the table data.
    mov r16, ZH                    
    push r16                       
    lds r16, CPU_RAMPZ             
    push r16
	ldi ZL, low(header << 1)		; Load each line and output it over UART.
	ldi ZH, high(header << 1)
	rcall OUT_STRING
	ldi ZL, low(food << 1)
	ldi ZH, high(food << 1)
	rcall OUT_STRING
	ldi ZL, low(course << 1)
	ldi ZH, high(course << 1)
	rcall OUT_STRING
	ldi ZL, low(hobby << 1)
	ldi ZH, high(hobby << 1)
	rcall OUT_STRING
	ldi ZL, low(quote << 1)
	ldi ZH, high(quote << 1)
	rcall OUT_STRING
	ldi ZL, low(movie << 1)
	ldi ZH, high(movie << 1)
	rcall OUT_STRING
	ldi ZL, low(menu << 1)
	ldi ZH, high(menu << 1)
	rcall OUT_STRING
	ldi ZL, low(done << 1)
	ldi ZH, high(done << 1)
	rcall OUT_STRING
	pop r16							; Restore r16 and the Z pointer.
    mov ZL, r16						
    out CPU_RAMPZ, r16             
    pop r16                        
    mov ZH, r16                    
    pop r16                        
    mov ZL, r16                    
    pop r16                        
    ret								; Return.
