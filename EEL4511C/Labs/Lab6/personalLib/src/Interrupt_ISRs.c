//  File:   Interrupt_ISRs.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"

Uint16 currentSramIndex = 0xFFC0;

interrupt void timer1Isr()
{
    CpuTimer1Regs.TCR.bit.TIF = 1;
    return;
}


interrupt void audioIsr(void)
{


    sram[(currentSramIndex&0x003F)] = McbspbRegs.DRR2.all;
    McbspbRegs.DXR2.all = (int16)lpf(lpfWeights,(currentSramIndex&0x003F));
    currentSramIndex = (currentSramIndex|0xFFC0)+1;

    Uint16 dummy = McbspbRegs.DRR1.all;
    McbspbRegs.DXR1.all = 0;
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP6;
}




