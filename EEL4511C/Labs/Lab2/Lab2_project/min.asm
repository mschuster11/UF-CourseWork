		.global		_c_int00	
		.ref		score_addr			; Start address of the scores vector.
		.ref		score_vector_len	; Address that holds of length the scores vector.
		.ref		min_addr			; Address that will hold the min value fo the scores vector.

WDCR			.set	0x7029
stackAddr		.set	0x400
minLocation		.set	0x9101


		.data
vectorLen		.word	19
vectorStart		.word	172
				.word	34
				.word	121
				.word	37
				.word	19
				.word	111
				.word	128
				.word	52
				.word	183
				.word	152
				.word	201
				.word	167
				.word	131
				.word	128
				.word	52
				.word	121
				.word	152
				.word	181
				.word	89




		.text
_c_int00:
			EALLOW

			MOV	 AL, #0x0068	;Disable Watchdog Timer in case we want to run this code on our board
			MOV	 AR1, #WDCR
			MOV	 *AR1, AL

			MOV	SP, #stackAddr


			MOV AR0, #vectorStart		; Load the vectors' addr, length, and location to store the min.
			MOV AR1, #vectorLen
			MOV AR2, #minLocation
			MOV AH, #255				; Load max possible bummy val
			MOV AL, *AR1
			B END1, EQ					; Check if nothing is loaded
LOOP		DEC *AR1
			MOV AL, *AR0
			CMP AL, AH
			B SAMEMIN, GT				; Compare current val and current min
			MOV *AR2, AL
			MOV AH, AL
SAMEMIN		INC AR0						; If current val < current min, replace min.
			MOV AL, *AR1
			B LOOP, NEQ
END1		B END1, UNC



