; Lab 2 part D
; Name:         Mark L. Schuster
; Section #:    1540
; TA Name:      Christopher Crary
; Description:  Program that establishes external SRAM at 0x200000 and writes the current switch values to the SRAM
;               every second. Additionally, the current value at the location of the stored switch values is outputted
;               to the LEDs every second. 

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;

.equ EBIBASEADDR = 0x200000       ; Value of the base address of where the external SRAM is to be mapped.
.equ EBIINIT = 0b01000001         ; Value to set the EBI to the 3-port, AEL1 with chip select mode and 8 bit reg sizes.
.equ ALL_OUT = 0xFF               ; 8-bit vector that will set an 8-bit GPIO port to output.
.equ ALL_IN = 0x00                ; 8-bit vector that will set an 8-bit GPIO port to input.
.equ EBI_PORTH_OUT = 0b11110111   ; 8-bit vector that will set all bits of port H as output aside from bit 3.
.equ EBISRAMEN = 0b00011101       ; Value to set the EBI to SRAM mode with a 32K address space.
.def clkPrescaler = r17           ; Denotes the input for the USE32MHzCLK input. Will hold the prescaler value.
.equ CLKEN = 0b0010               ; Enables the 32Mhz CLK.
.equ IOREG = 0xD8                 ; The value that sets the CPU_CCP reg to 'IOREG' mode.
.equ CLKPS = 0b00000000           ; Value that sets Prescaler A to 4. 
.equ CLKSEL = 1                   ; Value to select the 32MHz CLK.
.equ CLKOUT = 0b00000001          ; Value to output the CLK signal to port C.
.equ TCSEL = 0b0111               ; Value to set the prescaler of the TC to be 1024 time the period of the system CLK.
.equ TCPER = 0x7D00               ; Value of the TC period.      
.equ TCCMPAINT = 0b00010000       ; Value to init the TC compare A reg.
.equ TCCMPA_INTFLAGLOC = 4        ; Location of the compare interrupt flag in the TC's interrupt flags reg.

.org 0x0000
    rjmp init                     ; Start at 0x0000 and jump to program.

.org 0x100
init:
    sei                           ; Set the global interrupt bit.
    rcall INITEBI                 ; Call INITEBI.
    ldi clkPrescaler, CLKPS       ; Load the prescaler input for USE32MHzCLK and then call it.
    rcall USE32MHzCLK             ;
    rcall SETTIMER                ; Call SETTIMER.
portcInit:
    ldi r16, ALL_IN               ; Set 'initValue' to 8-bit GPIO input vector.
    sts PORTA_DIRSET, r16         ; Set PORTA to be input.
    ldi r16, ALL_OUT              ; Set 'initValue' to 8-bit GPIO output vector.
    sts PORTC_DIRSET, r16         ; Set PORTC to be output.
    ldi ZL, byte3(EBIBASEADDR)    ; Load the base address of the external SRAM into the Z
    out CPU_RAMPZ, ZL             ; and Y pointers.
    ldi ZH, byte2(EBIBASEADDR)    ; 
    ldi ZL, byte1(EBIBASEADDR)    ; 
    ldi YL, byte3(EBIBASEADDR)    ; 
    out CPU_RAMPY, YL             ; 
    ldi YH, byte2(EBIBASEADDR)    ; 
    ldi YL, byte1(EBIBASEADDR)    ; 

main:
    lds r16, TCC2_INTFLAGS        ; Check the compare A interrupt flag of the TC.
    mov r17, r16                  ; 
    andi r16, TCCMPAINT           ; 
    cpi r16, TCCMPAINT            ; 
    breq toggle                   ; If it is set, move to toggle. 
    rjmp main                     ; If not, loop to check again.
toggle:
    cbr r17, TCCMPA_INTFLAGLOC    ; Clear the interrupt flag from the TC's interrupt flags reg.
    sts TCC2_INTFLAGS, r17        ; 
    lds r16, PORTA_IN             ; Pull the current switch values and store them in the
    st Y, r16                     ; external SRAM.
    ld r17, Z                     ; Load the switch values back from SRAM and output them to 
    sts PORTC_OUT, r17            ; the LEDs.
    rjmp main                     ; Loop to wait for the flag to be set again.



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
; Subroutine Name: INITEBI
; Initialized the EBI
; Inputs: None
; Outputs: None
; Affected: r16, Z
INITEBI:
    push r16                      ; Preserve r16 and the Z pointer.
    mov r16, ZL                   ;
    push r16                      ;
    mov r16, ZH                   ;
    push r16                      ;
    lds r16, CPU_RAMPZ            ;
    push r16                      ;
    ldi r16, ALL_IN               ; Set port J to input.
    sts PORTJ_DIRSET, r16         ;
    ldi r16, ALL_OUT              ; Set port K to output.
    sts PORTK_DIRSET, r16         ;
    ldi r16, EBI_PORTH_OUT        ; Set all port H to output expect for bit 3 which goes unused.
    sts PORTH_DIRSET, r16         ;
    ldi r16, EBIINIT              ; Set the EBI to the 3-port, AEL1 with chip select mode with 8 bit reg sizes.
    sts EBI_CTRL, r16             ;
    ldi ZL, 0x00                  ; Clear Z's ramp, and set Z to the address of chip 0's base address. 
    out CPU_RAMPZ, ZL             ;
    ldi ZL, low(EBI_CS0_BASEADDR) ;
    ldi ZH, high(EBI_CS0_BASEADDR);
    ldi r16, byte2(EBIBASEADDR)   ; Then load the chosen base address into chip 0's base address's location.
    st Z+, r16                    ;
    ldi r16, byte3(EBIBASEADDR)   ;
    st Z, r16                     ;
    ldi r16, EBISRAMEN            ; Specify that chip 0 is SRAM with a 32K address space.
    sts EBI_CS0_CTRLA, r16        ;
    pop r16                       ; Restore r16 and the Z pointer.
    mov ZL, r16                   ;
    out CPU_RAMPZ, r16            ;
    pop r16                       ;
    mov ZH, r16                   ;
    pop r16                       ;
    mov ZL, r16                   ;
    pop r16                       ;
    ret                           ; Return.

.org 0x450
;*********************SUBROUTINES**************************************
; Subroutine Name: SETTIMER
; Initialized TCC2 by setting its period and compare A value.
; Inputs: None
; Outputs: None
; Affected: r16
SETTIMER:
    push r16                      ; Preserve r16.
    ldi r16, TCSEL                ; Enable the TC and set its period to be 1024 times that of the system CLK.
    sts TCC2_CTRLA, r16           ; 
    ldi r16, low(TCPER)           ; Load the period of the TC into the TC's period regs and load the same 
    sts TCC2_LPER, r16            ; value onto the TC's compare A reg.
    sts TCC2_LCMPA, r16           ; 
    ldi r16, high(TCPER)          ; 
    sts TCC2_HPER, r16            ; 
    sts TCC2_HCMPA, r16           ; 
    pop r16                       ; Restore r16.
    ret                           ; Return.
