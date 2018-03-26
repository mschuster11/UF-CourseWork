; Lab 1 part A
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  This assembly application reads the current state of
;               the switches on the 'SWITCH & LED BACKPACK' and turns
;               on the corrisponding LED.

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;

.def initVal = r16                ; Will hold the port DIRSET vlaues.
.def switchValues = r17           ; Will hold the switch's input value.
.equ ALL_IN = 0x00                ; 8-bit vector that will set an 8-bit GPIO port to input.
.equ ALL_OUT = 0xFF               ; 8-bit vector that will set an 8-bit GPIO port to output.

.org 0x0000
    rjmp init                     ; Start at 0x0000 and jump to program.

.org 0x200                        ; Start functionality at 0x200 to avoid precious interupt vectors.
init:
    ldi initVal, ALL_IN           ; Set 'initValue' to 8-bit GPIO input vector.
    sts PORTA_DIRSET, initVal     ; Set PORTA to be input.
    ldi initVal, ALL_OUT          ; Set 'initValue' to 8-bit GPIO output vector.
    sts PORTC_DIRSET, initVal     ; Set PORTC to be output.
    rjmp main                     
                      
main:                     
    lds switchValues, PORTA_IN    ; Load the switch's value into the 'switchValues'.
    sts PORTC_OUT, switchValues   ; Load 'switchValues' into the output to the LEDs.
    rjmp main                     ; Loop for continued updating.

