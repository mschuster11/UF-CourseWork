; Lab 0 part C
; Name:         Mark L. Schuster
; Section #:    1540
; TA NAme:      Christopher Crary
; Discription:  This assembly application filters data from a given input table 
;               based on the contraints listed in Lab0's lab doc.

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;

.equ tableSize  = 14
.def currentVal = r16             ; Set register 16 to be referred to as "currentVal".
.def temp       = r17             ; Set register 17 to be referred to as "temp".

.org 0x0000                       ; Start address at 0x0000.
    rjmp START                    ; Jump to the main segment of code.

.org 0x9000                       ; Store input table at 0x9000 as specified.

inputTable: .db 0x00, 108         ; Store input table byte-wise two at a time to avoid zero padding.
            .db 'G', 0b00100000
            .db 'I', 0106
            .db ':', 0x42
            .db 0b11110001, 74
            .db '!', 0xF7
            .db 0b00001101, 0x0A

.dseg                             ; Switch to data memory.

.org 0x3744                       ; Move to address 0x3744 as specified.

outputTable: .byte tableSize      ; Free space for the output table.

.cseg                             ; Switch back to program memory.

.org 0x200                        ; Place our program at 0x200.
START:
    clr currentVal                ; Initialize the register holding holding each table value to zero.
    ldi ZL, byte3(inputTable << 1); Temporarily store the most sigificant byte on the inputable's address in ZL.
    out CPU_RAMPZ, ZL             ; Load the upper thrid byte into the left most byte of the Z pointer.
    ldi ZH, byte2(inputTable << 1); Load the high byte of the input table into the Z pointer.
    ldi ZL, byte1(inputTable << 1); Load the low byte of the input table into the Z pointer.
    ldi YL, low(outputTable)      ; Point the Y pointer to the output
    ldi YH, high(outputTable)     ; table.

BEGIN:
    elpm currentVal, Z+           ; Begin by loading the current input table value into currentVal and incrementing the Z pointer.
    cpi currentVal, 0x0A          ; Check if the program has reached the end of the input table.
    breq FINAL                    ; If so, end the program.
    cpi currentVal, 109           ; Compare the current table value to 109.
    brlo LESSTHANONEZERONINE      ; If the current value is less than 109, continue with the algorithm.
    rjmp BEGIN                    ; If not, move to the next value in the input table.

LESSTHANONEZERONINE:                   
    cpi currentVal, 57            ; Compare the current value to 57.
    breq CHECKFIFTHBIT            ; If the current value is equal to 57, continue with the algorithm.
    brlo CHECKFIFTHBIT            ; If the current value is greater than 57, also continue with the algorithm.
    ldi temp, 9                   ; If not, load 9 into temp and proceed to increment the current value by 9.
    add currentVal, temp          ; 
    rjmp STORE                    ; Then jump to store the current value.
                            
CHECKFIFTHBIT:                      
    mov temp, currentVal          ; Copy the current value into "temp".
    andi temp, 0x20               ; Check is the 5th bit of the current value is set by ANDing it with 0b00100000.
    cpi temp, 0x20                ; Check if current value's 5th bit was set.
    breq STORE                    ; If so, jump to store the value.
    rjmp BEGIN                    ; If not, ignore the value.
                            
STORE:                            
    st Y+, currentVal             ; Store the current value in the output table, then increment the Y pointer.
    rjmp BEGIN                    ; Then process the next table value.
                            
FINAL:                            
    ldi currentVal, 0x00          ; "Cap" the output table by setting the last value to NULL (0x00).
    st Y, currentVal              ; 
    rjmp END                      ; Jump to the Finish
                            
END:                            
    rjmp END                      ; Infinite loop :-)
