; Lab 2 part B
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  Setup a timer/counter to run at 1024 times the period 
;       of the system clock and out put the lower byte of the 
;       count to be analyzed.

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;

.def clkPrescaler = r17           ; Denotes the input for the USE32MHzCLK input. Will hold the prescaler value.
.equ CLKEN = 0b0010               ; Enables the 32Mhz CLK.
.equ IOREG = 0xD8                 ; The value that sets the CPU_CCP reg to 'IOREG' mode.
.equ CLKPS = 0b00001100           ; Value that sets Prescaler A to 4. 
.equ CLKSEL = 1                   ; Value to select the 32MHz CLK.
.equ CLKOUT = 0b00000001          ; Value to output the CLK signal to port C.
.equ TCSEL = 0b0111               ; Value to set the prescaler of the TC to be 1024 time the period of the system CLK.
.equ TCPER = 0x00FF               ; Value of the TC period.
.equ ALLOUT = 0xFF                ; 8-bit vector that will set an 8-bit GPIO port to output.

.org 0x0000
    rjmp init                     ; Start at 0x0000 and jump to program.

.org 0x200
init:
    ldi clkPrescaler, CLKPS       ; Load the prescaler value and call USE32MHzCLK.
    rcall USE32MHzCLK             ;
                            
counterInit:
    ldi r16, TCSEL                ; Enable the TC and set its period to be 1024 times that of the system CLK.
    sts TCC2_CTRLA, r16           ; 
    ldi r16, low(TCPER)           ; Load the period of the TC into the TC's period regs.
    sts TCC2_LPER, r16            ; 
    ldi r16, high(TCPER)          ; 
    sts TCC2_HPER, r16            ; 
                            
portcInit:
    ldi r16, ALLOUT               ; Set port C to output.
    sts PORTC_DIRSET, r16         ; 
                            
main:                           
    lds r16, TCC2_LCNT            ; Load the lower byte of the TC's count and output it 
    sts PORTC_OUT, r16            ; to port C.
    rjmp main                     ; Repeat that action forever.

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
