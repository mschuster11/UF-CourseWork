
		.global	_c_int00


WDCR			.set	0x7029		;Watchdog Register is at address 0x7029
stackAddr		.set	0x400
arrayLen		.set	15
recipLen		.set	1.0/arrayLen


		.data
Min_Num			.float	0.0
Max_Num			.float	0.0
Ave_Num			.float	0.0
floatArray		.float 9999999999.0
				.float 178546.123654897
				.float 546.12367
				.float 38546.89723
				.float 46.1297
				.float 134462.12246854897
				.float 16.1223423483242347
				.float 9452436.0
				.float 4784546.1254897
				.float 27.197
				.float 3455546.145655344897
				.float -76543653454354897.0
				.float 13478546.123654897
				.float 904546.123
				.float 108006.54597
				.float 178546.34654897

	
		.text		

_c_int00:
			EALLOW

			MOV	AL, #0x0068						;Disable Watchdog Timer in case we want to run this code on our board
			MOV	AR1, #WDCR
			MOV	*AR1, AL

			MOV	SP, #stackAddr					; Init the stack pionter to 0x0400.

			PUSH #floatArray					; Pass the array's addr to the subroutine.
			PUSH #arrayLen						; Pass the array's length to the subroutine.
			LC MIN_NUMF							; Call the min subroutine.

			PUSH #floatArray					; Pass the array's addr to the subroutine.
			PUSH #arrayLen						; Pass the array's length to the subroutine.
			LC MAX_NUMF							; Call the max subroutine.
			POP AL

			PUSH #floatArray					; Pass the arrays addr to the subroutine.
			PUSH #arrayLen						; Pass the array's length to the subroutine.
			LC AVE_NUMF							; Call the average subroutine.
			POP AL

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
; Name: 		MIN_NUMF
; Description:	Finds the minimum value in an array of floats.
; Inputs:		R0H - int to be converted.
; Outputs:		R0H - Converted float.
MIN_NUMF:
			POP AR2						; Pop return addr from stack.
			POP AR3
			POP AR0						; Store array length addr.
			POP AR1						; Store array addr.
			PUSH AR3					; Restore return addr.
			PUSH AR2
			MOV AR3, #Min_Num			; Point AR3 to addr of min num.
			MOVL XAR4, *XAR1			; Place the first val of the array in min.
			MOVL *XAR3, XAR4

MIN_NUMF_COUNT:
			CMP AR0, #0					; Compare count to 0, end subroutine if equal.
			B MIN_NUMF_END, EQ
			MOV32 R0H, *XAR3			; Load R0H with the current min.
			MOV32 R1H, *XAR1++			; Load R1H with current array val; Increment array pointer.
			CMPF32 R0H, R1H				; Compare current min with current val.
			MOVST0 ZF, NF				; Move pertinent flags from FPU to CPU.
			B MIN_NUMF_NO_NEW_MIN, LT	; If current min is less than current val, continue.
			MOV32 *XAR3, R1H			; If not, replace current min with current val.

MIN_NUMF_NO_NEW_MIN:
			DEC AR0						; Decrement count.
			B MIN_NUMF_COUNT, UNC		; Loop back.

MIN_NUMF_END:
			MOVL ACC, *XAR3				; Place result in ACC.

			LRET						; Return.

;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		MAX_NUMF
; Description:	Finds the maximum value in an array of floats.
; Inputs:		R0H - int to be converted.
; Outputs:		R0H - Converted float.
MAX_NUMF:
			POP AR2						; Pop return addr from stack.
			POP AR3
			POP AR0						; Store array length addr.
			POP AR1						; Store array addr.
			PUSH AR3					; Restore return addr.
			PUSH AR2
			MOV AR3, #Max_Num			; Point AR3 to addr of max num.
			MOVL XAR4, *XAR1			; Place the first val of the array in max.
			MOVL *XAR3, XAR4

MAX_NUMF_COUNT:
			CMP AR0, #0					; Compare count to 0, end subroutine if equal.
			B MAX_NUMF_END, EQ
			MOV32 R0H, *XAR3			; Load R0H with the current max.
			MOV32 R1H, *XAR1++			; Load R1H with current array val; Increment array pointer.
			CMPF32 R0H, R1H				; Compare current max with current val.
			MOVST0 ZF, NF				; Move pertinent flags from FPU to CPU.
			B MAX_NUMF_NO_NEW_MAX, GT	; If current max is greater than current val, continue.
			MOV32 *XAR3, R1H			; If not, replace current max with current val.

MAX_NUMF_NO_NEW_MAX:
			DEC AR0						; Decrement count.
			B MAX_NUMF_COUNT, UNC		; Loop back.

MAX_NUMF_END:
			MOVL ACC, *XAR3				; Place result in ACC.

			LRET						; Return.

;~~~~~~~~~~~~~~~~~~~~~~~~~SUBROUTINE~~~~~~~~~~~~~~~~~~~~~~~~~;
; Name: 		AVE_NUMF
; Description:	Finds the average value of an array of floats.
; Inputs:		R0H - int to be converted.
; Outputs:		R0H - Converted float.
AVE_NUMF:

			POP AR2						; Pop return addr from stack.
			POP AR3
			POP AR0						; Store array length addr.
			POP AR1						; Store array addr.
			PUSH AR3					; Restore return addr.
			PUSH AR2
			MOV AR3, #Ave_Num			; Point AR3 to addr of the average.
			MOV32 R0H, *XAR3			; Init R0H to zero by loading the initial value at Ave_Num.

AVE_NUMF_COUNT:
			CMP AR0, #0					; Compare count to 0, end subroutine if equal.
			B AVE_NUMF_END, EQ
			MOV32 R1H, *XAR1++			; Move the current array element into R1H.
			ADDF32 R0H, R0H, R1H		; Add the current array value to the running sum in R0H.
			DEC AR0						; Decrement count.
			B AVE_NUMF_COUNT, UNC		; Loop back.

AVE_NUMF_END:
			MPYF32 R0H, R0H, #recipLen	; Multiply the array's sum by the number of elements.
			NOP							; Clear pipeline to return the standard fixed point use.
			NOP
			NOP
			NOP
			MOV32 *XAR3, R0H			; If not, replace current max with current val.
			MOVL ACC, *XAR3				; Place result in ACC.

			LRET						; Return.
