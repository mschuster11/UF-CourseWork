		.global		_c_int00	


WDCR			.set	0x7029
stackAddr		.set	0x400

GPAMUX1			.set	0x6F86
GPADIR			.set	0x6F8A
GPADAT			.set	0x6FC0
GPAPUD			.set	0x6F8C

GPBMUX1			.set	0x6F96
GPBDIR			.set    0x6F9A
GPBDAT			.set    0x6FC8
GPBPUD			.set    0x6F9C



		.text
_c_int00:
			EALLOW

			MOV	 AL, #0x0068	;Disable Watchdog Timer in case we want to run this code on our board
			MOV	 AR1, #WDCR
			MOV	 *AR1, AL

			MOV	SP, #stackAddr	; Init stack


			MOV AR0, #GPAMUX1	; Init the LEDs to GPIO
			MOV AL, *AR0
			AND AL, #0xFFF0
			MOV *AR0, AL
			INC AR0
			MOV AL, *AR0
			AND AL, #0x0003
			MOV *AR0, AL

			MOV AR0, #GPADIR	; Init LEDs to outputs
			MOV AL, *AR0
			OR AL, #0x7F80
			MOV *AR0, AL


			MOV AR0, #GPADAT	; Set values of LED
			MOV AL, *AR0
			AND AL, #0x807F
			MOV *AR0, AL


			MOV AR0, #GPAMUX1	; Init the switches to GPIO
			MOV AL, *AR0
			AND AL, #0xF30F
			MOV *AR0, AL

			MOV AR0, #GPAPUD	; Enable the pull-ups
			MOV AL, *AR0
			AND AL, #0xFF8B
			MOV *AR0, #0
			MOV *AR0, AL

			MOV AR0, #GPADIR	; Set the switches to inputs
			MOV AL, *AR0
			AND AL, #0xFF8B
			MOV *AR0, AL

			MOV AR0, #GPADAT	; Read the input data and echo it to the LEDs.
LOOP		MOV AL, *AR0
			MOV AH, AL

			AND AH, #0x0070
			AND AL, #0x0004
			LSL AL, 1
			OR AL, AH
			MOV AH, *AR0
			AND AH, #0x807F
			LSL AL, 4
			OR AH, AL
			LSL AL, 4
			OR AH, AL
			MOV *AR0, AH
			B LOOP, UNC
