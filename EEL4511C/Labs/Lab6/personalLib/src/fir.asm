		.cdecls C, NOLIST, "msLib.h"
		.def _lpfASM
		.ASG "R0H", res
		.ASG "AR1", itter
		.ASG "R1H", currentSample
		.ASG "R2H", currentWeight

		.define "*+XAR5", samplesPtr
		.define "*+XAR4", weightsPtr



_lpfASM:
		ZERO res
		MOV itter, #0
LPF_LOOP:
		CMP itter, #FILTER_TAP_NUM
		B LPF_DONE, EQ
		MOV AL, AR5
		SUB AL, itter
		MOV AR0, AL
		MOV AL, *AR0
		MOV32 currentSample, ACC
		NOP
		NOP
		NOP
		NOP
		I16TOF32 currentSample, currentSample
		NOP
		NOP
		NOP
		NOP
		MOV32 currentWeight, weightsPtr[itter]
		NOP
		NOP
		NOP
		MPYF32 currentSample, currentSample, currentWeight
		NOP
		ADDF32 res, res, currentSample
		INC itter
		B LPF_LOOP, UNC

LPF_DONE:
		LRETR
