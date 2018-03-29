		.cdecls C, NOLIST, "msLib.h"
		.def _firASM
		.ASG "R0H", result
		.ASG "AR1", itter
		.ASG "AR4", weightPtrLower16
		.ASG "AR5", samplePtrLower16
		.ASG "R1H", currentSample
		.ASG "R2H", currentWeight
		.ASG "R3H", currentProduct

		.define "*XAR4", weightPtr
		.define "*XAR5", samplePtr




_firASM:
		ZERO result
		MOV itter, AL

FIR_LOOP:
		CMP itter, #0
		B FIR_DONE, EQ
		MOV32 currentSample, samplePtr
		MOV32 currentWeight, weightPtr
		MPYF32 currentProduct, currentSample, currentWeight
		DEC itter
		INC weightPtrLower16
		INC weightPtrLower16
		DEC samplePtrLower16
		DEC samplePtrLower16
		ADDF32 result, result, currentProduct
		B FIR_LOOP, UNC

FIR_DONE:
		LRETR
