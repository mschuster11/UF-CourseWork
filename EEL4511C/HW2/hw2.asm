		.global		_c_int00

negCount		.set	0x9100

		.data
vectorStart		.word	12
				.word	34
				.word	-12
				.word	2
				.word	19
				.word	-67
				.word	128
				.word	-52
				.word	12
				.word	-152
				.word	-1
				.word	0


		.text
_c_int00:

			MOV AR0, #vectorStart
			MOV AR1, #negCount
			MOV *AR1, #0
LOOP		MOV AL, *AR0
			B END1, EQ
			INC AR0
			CMP AL, #0
			B LOOP, GEQ
			INC *AR1
			MOV AL, *AR1
			B LOOP, NEQ
END1		B END1, UNC
