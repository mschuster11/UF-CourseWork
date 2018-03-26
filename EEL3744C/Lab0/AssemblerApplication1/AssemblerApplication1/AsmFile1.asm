; (BSORT.ASM) Ascending Bubble Sort Program
; By A. George
; Created:  2/2/02
; Modified: 2/4/02 (fixed typos in comment field)
; This program contains a subroutine for ascending bubble sort along with
; test code to demonstrate that it works correctly.

.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;


.org 0x0000
    rjmp init                     ; Start at 0x0000 and jump to program.


.org	0x200
init:
	ldi r16, 0x37
	push r16
	ldi r16, 0xAB
	push r16
	ldi r16, 0xEF
	push r16
	ldi r16, 0x12
	push r16
	rcall subr
	jmp done

done:
	jmp done

subr:
	ldi r16, 0x1c
	push r16
	ret
