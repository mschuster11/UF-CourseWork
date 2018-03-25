//  File:   Interrupt_ISRs.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"


interrupt void timer1Isr()
{
    CpuTimer1Regs.TCR.bit.TIF = 1;
    return;
}


interrupt void audioIsr(void)
{
    McbspbRegs.DXR1.all = McbspbRegs.DRR1.all;
    McbspbRegs.DXR2.all = McbspbRegs.DRR2.all;
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP6;
}




