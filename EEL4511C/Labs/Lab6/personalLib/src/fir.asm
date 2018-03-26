		.cdecls C, NOLIST, "msLib.h"
		.def _lpfASM
		.ASG "XAR5", sram
		.ASG "XAR4", sram
		.ASG "XAR0", offset
		.ASG "R0H", res
		.ASG "AR1", itter

		.define "*+XAR5", sramPtr
		.define "*+XAR4", weightsPtr



_lpfASM:
		ZERO res
		MOV itter, #0
		MOV AL, AR0
		OR AL, #0xFFC0
		MOV AR2, AL
		INC AR4
LPF_LOOP:
		CMP itter, #FILTER_TAP_NUM
		B LPF_DONE, EQ

		AND AL, #0x003F
		SUB AL, itter
		AND AL, #0x003F
		MOV AR0, AL
		MOV AL, sramPtr[AR0]
		MOV AH, #0
		MOV32 R1H, ACC
		NOP
		NOP
		NOP
		NOP
		I16TOF32 R1H, R1H

		MOV32 R2H, weightsPtr[itter]
		NOP
		MOV AL, AR2
		MPYF32 R1H, R1H, R2H
		NOP
		ADDF32 res, res, R1H
		INC itter
		B LPF_LOOP, UNC

LPF_DONE:
		LRETR
