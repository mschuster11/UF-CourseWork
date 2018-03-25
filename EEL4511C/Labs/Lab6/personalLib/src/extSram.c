//  File:   extSram.c
//  Date:   03/08/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"

#pragma DATA_SECTION(sram, ".extsram")
Uint16 sram[0x40000];

void initExtSRAM(void){
    EALLOW;
    SysCtrlRegs.PCLKCR3.bit.XINTFENCLK = 1;
    GpioCtrlRegs.GPAMUX2.all |= 0xFF000000;
    GpioCtrlRegs.GPBMUX1.all |= 0xFFFFF000;
    GpioCtrlRegs.GPCMUX1.all |= 0xFFFFFFFF;
    GpioCtrlRegs.GPCMUX2.all |= 0xFFFF;

    EDIS;
}

