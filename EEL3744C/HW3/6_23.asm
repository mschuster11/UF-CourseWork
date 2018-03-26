.nolist                           ; Included for fun.
.include "ATxmega128A1Udef.inc"   ;
.list                             ;

.equ tabelLen = 32

.org 0x0000
    rjmp init                     ; Start at 0x0000 and jump to program.


.org	0x400
Table:	.db	9,1,7,2,4,3,8,6,5,-1,21,53,45,-12,2,32,42,53,51,56,74,23,1,63,56,456,34,89,60,467,40,12	; table for use in testing BSORT subroutine

.dseg
.org 0x2000 
output: .byte 1

.cseg



.org	0x200
init:
	ldi ZL, low(Table << 1)
	ldi ZH, high(Table << 1)
	ldi YL, low(output)
	ldi YH, high(output)
	ldi r18, 0x00
loopinit:
	cpi r18, tabelLen
	breq main
	lpm r16, Z+
	st Y+, r16
	inc r18
	jmp loopinit
main:

	rcall smallest
	jmp done

done: 
	jmp done

.org 0x300


smallest:
    push r16  
	push r17 
	push r18                              
	ldi YL, low(output)
	ldi YH, high(output)

	ldi r18, 0x00
	ld r16, Y+
loop:  
	cpi r18, tabelLen
	breq end               
    ld r17, Y+
	cp r17, r16
	brge endloop
	mov r16, r17
endloop:
	inc r18
	jmp loop

end:
	st -Y, r16
	pop r18
	pop r17
	pop r16
	ret
