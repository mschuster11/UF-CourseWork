; THIS IS MARK L SCHUSTER'S CODE MY DUDE PLEASE DONE COPY THIS BIIIIII
		.global	_c_int00
	.ref vector, length, cdf

WDCR			.set 	0x7029		;Watchdog Register is at address 0x7029
PCLKCR3			.set	0x7020
stackAddr		.set 	0x400
sramAddrStart	.set	0x100000
sramAddrEnd		.set	0x13FFFF
arrayLen		.set	15
recipLen		.set	1.0/arrayLen

GPAMUX1			.set	0x6F86
GPAMUX2			.set	0x6F88
GPADIR			.set	0x6F8A
GPADAT			.set	0x6FC0
GPAPUD			.set	0x6F8C

GPBMUX1			.set	0x6F96
GPBMUX2			.set	0x6F98
GPBDIR			.set    0x6F9A
GPBDAT			.set    0x6FC8
GPBPUD			.set    0x6F9C

GPCMUX1			.set	0x6FA6
GPCMUX2			.set	0x6FA8
GPCDIR			.set    0x6FAA
GPCDAT			.set    0x6FD0
GPCPUD			.set    0x6FAC


		.data
Min_Num			.float	0.0
Max_Num			.float	0.0
Ave_Num			.float	0.0
floatArray		.float	15.0;.float 9999999999.0
				.float	15.0;.float 178546.123654897
				.float	15.0;.float 546.12367
				.float	15.0;.float 38546.89723
				.float	15.0;.float 46.1297
				.float	15.0;.float 134462.12246854897
				.float	15.0;.float 16.1223423483242347
				.float	15.0;.float 9452436.0
				.float	15.0;.float 4784546.1254897
				.float	15.0;.float 27.197
				.float	10.0;.float 3455546.145655344897
				.float	10.0;.float -76543653454354897.0
				.float	10.0;.float 13478546.123654897
				.float	10.0;.float 904546.123
				.float	10.0;.float 108006.54597
				.float	10.0;.float 178546.34654897


		.text

_c_int00:			EALLOW

			MOV	AL, #0x0068						;Disable Watchdog Timer in case we want to run this code on our board
			MOV	AR1, #WDCR
			MOV	*AR1, AL

			MOV	SP, #stackAddr					; Init the stack pionter to 0x0400.
			LC INIT_SRAM

			MOV AR0, #length
			PUSH #vector					; Pass the arrays addr to the subroutine.
			PUSH *AR0					; Pass the array's length to the subroutine.
			LC CNDF							; Call the average subroutine.


PRGM_END:
			B PRGM_END, UNC



;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		Int16_Float32
; Description:	Converts a 16-bit int into a 32-bit float.
; Inputs:		R0H - int to be converted.
; Outputs:		R0H - Converted float.
Int16_Float32:
			I16TOF32 R0H,R0H
			NOP
			NOP
			NOP
			NOP

			LRET

;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		Float32_Int16
; Description:	Converts a 32-bit float into a 16-bit int.
; Inputs:		R0H - float to be converted.
; Outputs:		R0H - Converted int.
Float32_Int16:
			F32TOUI16 R0H,R0H
			NOP
			NOP
			NOP
			NOP

			LRET



;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		CNDF
; Description:	Finds the CNDF of an array of floats.
; Inputs:		R0H - int to be converted.
; Outputs:		R0H - Converted float.
CNDF:

			POP AR2						; Pop return addr from stack.
			POP AR3
			POP AR0						; Store array length addr.
			POP AR1						; Store array addr.
			PUSH AR3					; Restore return addr.
			PUSH AR2

			MOVL XAR3, #cdf			; Point AR3 to addr of the average.
			MOV32 R0H, *XAR3			; Init R0H to zero by loading the initial value at Ave_Num.
			PUSH AR0
			PUSH AR1
CNDF_SUM_COUNT:
			CMP AR0, #0					; Compare count to 0, end subroutine if equal.
			B CNDF_SUM_FOUND, EQ
			MOV32 R1H, *XAR1++			; Move the current array element into R1H.
			ADDF32 R0H, R0H, R1H		; Add the current array value to the running sum in R0H.
			DEC AR0						; Decrement count.
			B CNDF_SUM_COUNT, UNC		; Loop back.

CNDF_SUM_FOUND:
			EINVF32 R5H, R0H
			NOP
			NOP
			NOP
			MOVL XAR4, #0
			MOV32 R2H, XAR4
			POP AR1
			POP AR0

CNDF_MUL_RECIP_SUM:
			CMP AR0, #0					; Compare count to 0, end subroutine if equal.
			B AVE_NUMF_END, EQ
			MOV32 R1H, *XAR1++			; Move the current array element into R1H.
			ADDF32 R2H, R2H, R1H		; Add the current array value to the running sum in R0H.
			NOP
			NOP
			MPYF32 R3H, R5H, R2H
			NOP
			NOP
			MOV32 *XAR3++, R3H
			DEC AR0						; Decrement count.
			B CNDF_MUL_RECIP_SUM, UNC		; Loop back.
			MOV32 *XAR3, R0H			; If not, replace current max with current val.
			MOVL ACC, *XAR3				; Place result in ACC.
AVE_NUMF_END:
			LRET						; Return.


;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		INIT_SRAM
; Description:	Inits the GPIO that interact with the SRAM.
; Inputs:		None.
; Outputs:		None.
INIT_SRAM:
			MOVL XAR0, #0
			MOV AR0, #PCLKCR3					; Enable the peripheral clock.
			TSET *AR0, #12
			MOV AR0, #GPAMUX2+1					; Enable XZCS6.L, XA19-17.
			TSET *AR0, #8
			TSET *AR0, #9
			TSET *AR0, #10
			TSET *AR0, #11
			TSET *AR0, #12
			TSET *AR0, #13
			TSET *AR0, #14
			TSET *AR0, #15
			MOV AR0, #GPBMUX1					; Enable XWE0.L, XA16.
			TSET *AR0, #12
			TSET *AR0, #13
			TSET *AR0, #14
			TSET *AR0, #15
			MOV AL, #0xFFFF
			MOV AR0, #GPBMUX1+1					; Enable XA7-0.
			MOV *AR0, AL
			MOV AR0, #GPCMUX1					; Enable XD15-8.
			MOV *AR0, AL
			MOV AR0, #GPCMUX1+1					; Enable XD7-0.
			MOV *AR0, AL
			MOV AR0, #GPCMUX2					; Enable XA15-8.ZZ
			MOV *AR0, AL

			LRET
