;****************************************************************************************
; File = FPU_Ex1.asm - Dr. Karl Gugel 2015
; This program takes read a digital value (i.e. ADC output) and computes the integer one's
; digit portion and the integer tenth's digit portion. To illustrate how to use the FPU
; instructions.  VERY IMPORTANT See sprueo2b.pdf for the FPU instructions & useage.
;
; Also VERY IMPORTANT in CCS6:
; See project properties > CCSBuild > C2000 Compiler > Processor options
; In the “Specify floating point support” field, make sure “fpu32” is selected.
;
	.global	_c_int00	;This assembler directive allows _c_int00 to be a
				;global variable. This tells the linker where your
				;program (.text code) begins and where to boot from.
;
;****************************************************************************************
;***************************** Program Constants ****************************************
WDCR		.set		0x7029		;Watchdog Register is at address 0x7029
fIn			.set	212
;****************************************************************************************
;******************* DATA ALLOCATION SECTION - Variables/Data ***************************
	.sect	".cinit"		;data section, starting at 0x8000.
Temp0		.float	9.9		;For floating pt viewing purposes, 9.9 is random data

CtoF		.float	1.8	;Resolution = 3.3V/2^12
FtoC		.float	5.0/9.0	;Resolution = 3.3V/2^12
FtoCConst	.float  32.0*(5.0/9.0)
Ones		.word	0		;1's digit answer
Tenths		.word	0		;1/10's digit answer


				;.global directive to see variables in map file
	.global			Temp0,ADC_Value,Resolut,Ones,Tenths
;****************************************************************************************

;************************ FPU Program Example ****************************
	.text		;Program section, program code starts at 0x9000
_c_int00:
	EALLOW		;Enable Protected register write. Needed to change control registers.

	MOV	AL, #0x0068	;Disable Watchdog Timer in case we want to run on DSP board
	MOV	AR0, #WDCR
	MOV	*AR0, AL

	MOV	SP, #0x400	;Initialize SP in case we use a subroutine

	MOVL	XAR0, #fIn	;12 bit unsigned A/D with VrefH = 3.3V and VrefL = 0V
				;you must use XAR7:0 for indirect addressing later on

	;MOV	AL, *AR0		;Get 12 bit ADC test value
	;MOV	AH, #0x0		;zero upper word, we will use ACC to pass data to float reg

				;R7H:R0H are 32 bit regs that can be used as INTEGERs or FLOATs
	MOV32	R0H,XAR0	;Move in 32 bit INTEGER ADC value
	NOP			;When transferring to FPU Register you must align the pipeline
	NOP
	NOP
	NOP

	LC	Int16_Float32	;convert to float using my subroutine, argument passed via R0H

	;Finally we can do some FPU MATH, Remember FPU Regs can be used for Integers or Floats!
	;3.3V => 2^12 so Resolution = 3.3/4096 = 0.00080566V/Bit
	;Note for Test Data: 3125*0.00080566 = 2.52V
	;This code will now compute 1's digit (integer) and 1/10's digit (integer) portion.
	;i.e. '2' and '5' in this example.  Useful for displaying to an LCD... Voltmeter app.


				;COMPUTE ADC * RESOLUTION
	MOVL	XAR0,#FtoC	;R0H = ADC Value, R1H = Resolution = Volts/Bit
	MOV32	R1H,*XAR0
	MPYF32	R0H,R1H,R0H
	MOVL	XAR0,#FtoCConst	;R0H = ADC Value, R1H = Resolution = Volts/Bit
	MOV32	R1H, *XAR0
	SUBF32	R0H, R0H, R1H
				;Compute ONE's DIGIT VALUE
	LC	Float32_Int16	;Get rid of the fractional portion of ADC * Resolution

	MOV32	XAR0,R0H

End1:	B	End1,unc


******************************************************************************************
***************** Subroutines Created For Float/Int Conversions **************************
******************************************************************************************

Int16_Float32:				;Integer to Float, R0H In and R0H Out
	I16TOF32 R0H,R0H		;16 bit integer to 32 bit float
	NOP				;delays to clear pipeline before moving to ACC
	NOP
	MOVL	XAR0,#Temp0		;Debug Purposes, view FLOAT VALUE in memory
	MOV32	*XAR0,R0H
	LRET


Float32_Int16:
	F32TOUI16 R0H,R0H		;Convert to integer (lower 16 bits of R0H)
	NOP				;pipeline delay purposes
	NOP
	MOVL	XAR0,#Temp0		;Debug Purposes, view INTEGER VALUE in memory
	MOV32	*XAR0,R0H
	LRET
******************************************************************************************
******************************************************************************************
******************************************************************************************

;List File Lines for Viewing Memory Variables =>
;
;15 ;****************************************************************************************
;16 ;***************************** Program Constants ****************************************
;17 7029  WDCR      .set            0x7029          ;Watchdog Register is at address 0x7029
;18 ;****************************************************************************************
;19 ;******************* DATA ALLOCATION SECTION - Variables/Data ***************************
;20 00000000       .sect      ".cinit"               ;data section, starting at 0x8000.
;21 00000000 6666  Temp0       .float    9.9         ;For floating pt viewing purposes
;   00000001 411E
;22 00000002 0C35  ADC_Value   .word     3125        ;12 Bit Unsigned A/D test value, 2.5 Volt
;23 00000004 32ED  Resolut     .float    0.00080566  ;Resolution = 3.3V/2^12
;   00000005 3A53
;24 00000006 0000  Ones        .word     0           ;1's digit answer
;25 00000007 0000  Tenths      .word     0           ;1/10's digit answer

