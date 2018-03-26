; Lab 2 part C
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  Initialize the SRAM's mapped address to 0x200000 using the EBI

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;

.equ EBIBASEADDR = 0x200000       ; Value of the base address of where the external SRAM is to be mapped.
.equ EBIINIT = 0b01000001         ; Value to set the EBI to the 3-port, AEL1 with chip select mode and 8 bit reg sizes.
.equ ALL_OUT = 0xFF               ; 8-bit vector that will set an 8-bit GPIO port to output.
.equ ALL_IN = 0x00                ; 8-bit vector that will set an 8-bit GPIO port to input.
.equ EBI_PORTH_OUT = 0b11110111   ; 8-bit vector that will set all bits of port H as output aside from bit 3.
.equ EBISRAMEN = 0b00011101       ; Value to set the EBI to SRAM mode with a 32K address space.

.org 0x0000
    rjmp init                     ; Start at 0x0000 and jump to program.

.org 0x200
init:
    ldi ZL, byte3(EBIBASEADDR)    ; Load the SRAM base address into both the Z and Y pointers.
    out CPU_RAMPZ, ZL             ; 
    ldi ZH, byte2(EBIBASEADDR)    ; 
    ldi ZL, byte1(EBIBASEADDR)    ; 
    ldi YL, byte3(EBIBASEADDR)    ; 
    out CPU_RAMPY, YL             ; 
    ldi YH, byte2(EBIBASEADDR)    ; 
    ldi YL, byte1(EBIBASEADDR)    ; 
    rcall INITEBI                 ; Call the INITEBI subroutine.

loop:
    ldi r16, 0xA5                 ; Load 0xa5 into a reg and write it to the SRAM.
    st Y, r16                     ; 
    ld r17, Z                     ; Load the written value back from the SRAM.

    rjmp loop                     ; Loop endlessly.

.org 0x300
;*********************SUBROUTINES**************************************
; Subroutine Name: INITEBI
; Initialized the EBI
; Inputs: None
; Outputs: None
; Affected: r16, Z
INITEBI:
    push r16                       ; Preserve r16 and the Z pointer.
    mov r16, ZL                    ;
    push r16                       ;
    mov r16, ZH                    ;
    push r16                       ;
    lds r16, CPU_RAMPZ             ;
    push r16                       ;
    ldi r16, ALL_IN                ; Set port J to input.
    sts PORTJ_DIRSET, r16          ;
    ldi r16, ALL_OUT               ; Set port K to output.
    sts PORTK_DIRSET, r16          ;
    ldi r16, EBI_PORTH_OUT         ; Set all port H to output expect for bit 3 which goes unused.
    sts PORTH_DIRSET, r16          ;
    ldi r16, EBIINIT               ; Set the EBI to the 3-port, AEL1 with chip select mode with 8 bit reg sizes.
    sts EBI_CTRL, r16              ;
    ldi ZL, 0x00                   ; Clear Z's ramp, and set Z to the address of chip 0's base address. 
    out CPU_RAMPZ, ZL              ;
    ldi ZL, low(EBI_CS0_BASEADDR)  ;
    ldi ZH, high(EBI_CS0_BASEADDR) ;
    ldi r16, byte2(EBIBASEADDR)    ; Then load the chosen base address into chip 0's base address's location.
    st Z+, r16                     ;
    ldi r16, byte3(EBIBASEADDR)    ;
    st Z, r16                      ;
    ldi r16, EBISRAMEN             ; Specify that chip 0 is SRAM with a 32K address space.
    sts EBI_CS0_CTRLA, r16         ;
    pop r16                        ; Restore r16 and the Z pointer.
    mov ZL, r16                    ;
    out CPU_RAMPZ, r16             ;
    pop r16                        ;
    mov ZH, r16                    ;
    pop r16                        ;
    mov ZL, r16                    ;
    pop r16                        ;
    ret                            ; Return.
