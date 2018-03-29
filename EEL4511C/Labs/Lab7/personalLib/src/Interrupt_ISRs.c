//  File:   Interrupt_ISRs.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"

float sampleBuffer[SAMPLE_BUFFER_SIZE];

interrupt void timer1Isr()
{
    CpuTimer1Regs.TCR.bit.TIF = 1;
    return;
}

enum
{
    LEFT,
    RIGHT,
};

interrupt void audioIsr(void)
{
    static Uint16 currentBufIndex = 0xFF00;
    static Uint16 state = LEFT;
    if(state == LEFT)
    {
        GpioDataRegs.GPATOGGLE.bit.GPIO14 = 1;
        float sample = (float)(int16)McbspbRegs.DRR2.all;
        sampleBuffer[currentBufIndex&SAMPLE_BUFFER_MASK_OFF] = sample/(1<<15);
        sampleBuffer[SAMPLE_BUFFER_OFFSET + (currentBufIndex&SAMPLE_BUFFER_MASK_OFF)] = sample/(1<<15);

        float* currentBufPtr = sampleBuffer+(SAMPLE_BUFFER_OFFSET + (currentBufIndex&SAMPLE_BUFFER_MASK_OFF));

//        McbspbRegs.DXR2.all = (int16)(10.0f*firC(lpfFirWeights, currentBufPtr, FILTER_TAP_NUM_FIR_LPF));
//        McbspbRegs.DXR2.all = (int16)(10.0f*firASM(lpfFirWeights, currentBufPtr, FILTER_TAP_NUM_FIR_LPF));


//        McbspbRegs.DXR2.all = (int16)(10.0f*firC(bpfFirWeights, currentBufPtr, FILTER_TAP_NUM_FIR_BPF));
//        McbspbRegs.DXR2.all = (int16)(firASM(bpfFirWeights, currentBufPtr, FILTER_TAP_NUM_FIR_BPF));

//        McbspbRegs.DXR2.all = (int16)(10.0f*firC(hpfFirWeights, currentBufPtr, FILTER_TAP_NUM_FIR_HPF));
//        McbspbRegs.DXR2.all = (int16)(firASM(hpfFirWeights, currentBufPtr, FILTER_TAP_NUM_FIR_HPF));

//        McbspbRegs.DXR2.all = (int16)(12.0*iirLpf(FILTER_IIR_LPF_NUM_CASCADED_STAGES, FILTER_IIR_SOS_COLUMNS, lpfIirWeights, currentBufPtr));
        McbspbRegs.DXR2.all = (int16)(12.0*iirBpf(FILTER_IIR_BPF_NUM_CASCADED_STAGES, FILTER_IIR_SOS_COLUMNS, bpfIirWeights, currentBufPtr));

        currentBufIndex = (currentBufIndex|SAMPLE_BUFFER_MASK_ON)+1;
        GpioDataRegs.GPATOGGLE.bit.GPIO14 = 1;
    }

    Uint16 dummy = McbspbRegs.DRR2.all;
    dummy = McbspbRegs.DRR1.all;
    McbspbRegs.DXR1.all = 0;
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP6;
    state ^= 1;

}
