//  File:   Timer1_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"
#include "Timer1_Utils.h"
#include "Interrupt_ISRs.h"


void initTimer1(void){
    InitCpuTimers();
    ConfigCpuTimer(&CpuTimer1, 150, 1E5);
    EALLOW;
    PieVectTable.XINT13 = timer1Isr;
    IER |= M_INT13;
    EDIS;
    CpuTimer1.RegsAddr->TCR.bit.TSS = 0;
}
