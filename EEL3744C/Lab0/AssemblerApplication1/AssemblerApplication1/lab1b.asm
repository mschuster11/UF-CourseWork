; Lab 1 part B
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  This assembly application causes a LED to blink
;				with variable period using delay subroutines.

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;

.def initVal = r16                ; Will hold the port DIRSET vlaues.
.def ledToggle = r17              ; Will hold the value for the port output toggle.
.def countA = r18                 ; Will hold the count for the outer busy loop.
.def countB = r19                 ; Will hold the count for the inner busy loop.
.def delayTime = r20              ; Will hold the scaler for the number of times the 10ms delay is to occur.
.def temp = r21                   ; Will hold the count for how many 10ms delays have occured.
.equ ALL_OUT = 0xFF               ; 8-bit vector that will set an 8-bit GPIO port to output.
.equ LED_OFF = 0xFF               ; Used to initalize the LEDs to off.
.equ LED_TOGGLE = 0x01            ; Used to toggle the right-most LED.
.equ numberOfDelays = 127

.org 0x0000
    rjmp init                     ; Start at 0x0000 and jump to program.

.org 0x200
init:
    ldi initVal, ALL_OUT          ; Store the 8-bit output vector in 'initVal'.
    sts PORTC_DIRSET, initVal     ; Set portc to an output.
    ldi initVal, LED_OFF          ; Store the initial LED state in 'initVal'.
    sts PORTC_OUT, initVal        ; Set the LEDs to the initial value.
    ldi ledToggle, LED_TOGGLE     ; Set the LED toggle value.
    ldi delayTime, numberOfDelays ; Set the arbirtrary number of 10ms delays.
    rjmp main                     ; 

main:
    sts PORTC_OUTTGL, ledToggle   ; Toggle the LED.
    rcall DELAY_10ms              ; Call DELAYx10ms.
    rjmp main                     ; Repeat.

.org 0x250
;*********************SUBROUTINES**************************************
; Subroutine Name: DELAYx10ms
; Causes the device to pause operation for delayTime x 10ms.
; Inputs: delayTime
; Ouputs: None
; Affected: None

DELAYx10ms:
    push delayTime                ; Store the contents of delayTime.
    push temp                     ; Store the contents of temp.
    ldi temp, 0x00                ; Initalize temp to zero.
delayXLoop:                       
    cp temp, delayTime            ; Compare current count of delays and the total number of delays.
    breq exitDELAYx10ms           ; Exit if they are equal.
    rcall DELAY_10ms              ; If not, perform a 10ms delay.
    inc temp                      ; Increment the count.
    rjmp delayXLoop               ; Repeat.
                                    
exitDELAYx10ms:                                   
    pop temp                      ; Restore temp.
    pop delayTime                 ; Restore delayTime.
    ret                           ; Return.

.org 0x300
;*********************SUBROUTINES**************************************
; Subroutine Name: DELAY_10ms
; Causes the device to pause operation for 10ms.
; Inputs: None
; Ouputs: None
; Affected: None

DELAY_10ms:
    push countA                   ; Store the contents of countA.
    push countB                   ; Store the contents of countB.
    ldi countA, 0x00              ; Initalize countA to zero.
    ldi countB, 0x00              ; Initalize countB to zero.
outerLoop:                          
    cpi countA, 0x08              ; Compare countA with 0x08. 
    breq exitDELAY_10ms           ; If equal, exit.
innnerLoop:                          
    cpi countB, 0xFD              ; If not, compare countB with 0xFD. 
    breq incCountA                ; If equal, exit the inner loop.
    inc countB                    ; Increment countB.
    rjmp innnerLoop               ; Return to the nested loop.
incCountA:                         
    ldi countB, 0x00              ; Reset countB.
    inc countA                    ; Increment countA.
    rjmp outerLoop                ; return to the outer loop.
                                 
exitDELAY_10ms:                   
    pop countB                    ; Restore countB.
    pop countA                    ; Restore countA.
    ret                           ; Return.