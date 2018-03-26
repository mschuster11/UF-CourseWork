
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
