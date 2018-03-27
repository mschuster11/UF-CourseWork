//  File:   Interrupt_ISRs.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"

Uint16 currentBufIndex = 0xF800;
int16 sampleBuffer[SAMPLE_BUFFER_SIZE];


interrupt void timer1Isr()
{
    CpuTimer1Regs.TCR.bit.TIF = 1;
    return;
}


interrupt void audioIsr(void)
{
    GpioDataRegs.GPATOGGLE.bit.GPIO14 = 1;
    sampleBuffer[currentBufIndex&0x007F] = McbspbRegs.DRR2.all;
    sampleBuffer[SAMPLE_BUFFER_OFFSET + (currentBufIndex&0x007F)] = McbspbRegs.DRR2.all;



    int16 asmFir = (int16)lpfASM(lpfWeights, sampleBuffer+(SAMPLE_BUFFER_OFFSET + (currentBufIndex&0x007F)));
//    int16* currentSample = sampleBuffer+(SAMPLE_BUFFER_OFFSET + (currentBufIndex&0x007F));
//    float res = 0;
//    for(int i=0;i<FILTER_TAP_NUM;i++)
//        res+=lpfWeights[i]*(float)currentSample[-i];
    McbspbRegs.DXR2.all = sampleBuffer[currentBufIndex&0x007F];

    currentBufIndex = (currentBufIndex|0xFF80)+1;

    Uint16 dummy = McbspbRegs.DRR1.all;
    McbspbRegs.DXR1.all = 0;
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP6;
    GpioDataRegs.GPATOGGLE.bit.GPIO14 = 1;
}




