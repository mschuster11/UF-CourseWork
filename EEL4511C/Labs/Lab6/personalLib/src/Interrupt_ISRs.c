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
        sampleBuffer[currentBufIndex&SAMPLE_BUFFER_MASK_OFF] = sample;
        sampleBuffer[SAMPLE_BUFFER_OFFSET + (currentBufIndex&SAMPLE_BUFFER_MASK_OFF)] = sample;

//        McbspbRegs.DXR2.all = (int16)(10.0f*firC(lpfWeights, (sampleBuffer+(SAMPLE_BUFFER_OFFSET + (currentBufIndex&SAMPLE_BUFFER_MASK_OFF))), FILTER_TAP_NUM_LPF));
//        McbspbRegs.DXR2.all = (int16)(10.0f*firASM(lpfWeights, (sampleBuffer+(SAMPLE_BUFFER_OFFSET + (currentBufIndex&SAMPLE_BUFFER_MASK_OFF))), FILTER_TAP_NUM_LPF));


//        McbspbRegs.DXR2.all = (int16)(10.0f*firC(bpfWeights, (sampleBuffer+(SAMPLE_BUFFER_OFFSET + (currentBufIndex&SAMPLE_BUFFER_MASK_OFF))), FILTER_TAP_NUM_BPF));
//        McbspbRegs.DXR2.all = (int16)(firASM(bpfWeights, (sampleBuffer+(SAMPLE_BUFFER_OFFSET + (currentBufIndex&SAMPLE_BUFFER_MASK_OFF))), FILTER_TAP_NUM_BPF));

//        McbspbRegs.DXR2.all = (int16)(10.0f*firC(hpfWeights, (sampleBuffer+(SAMPLE_BUFFER_OFFSET + (currentBufIndex&SAMPLE_BUFFER_MASK_OFF))), FILTER_TAP_NUM_HPF));
        McbspbRegs.DXR2.all = (int16)(firASM(hpfWeights, (sampleBuffer+(SAMPLE_BUFFER_OFFSET + (currentBufIndex&SAMPLE_BUFFER_MASK_OFF))), FILTER_TAP_NUM_HPF));

        currentBufIndex = (currentBufIndex|SAMPLE_BUFFER_MASK_ON)+1;
        GpioDataRegs.GPATOGGLE.bit.GPIO14 = 1;
    }

    Uint16 dummy = McbspbRegs.DRR2.all;
    dummy = McbspbRegs.DRR1.all;
    McbspbRegs.DXR1.all = 0;
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP6;
    state ^= 1;

}
