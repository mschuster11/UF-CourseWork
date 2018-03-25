//  File:   LEDs_switches_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"



void initLEDSAndSwitches(void){
    // Allow write to protected regs.
    EALLOW;
    GpioCtrlRegs.GPAMUX1.all &= 0x0003FFF0;
    GpioCtrlRegs.GPADIR.all  |= 0x00007F80;
    GpioCtrlRegs.GPAMUX1.all &= 0xFFFFF30F;
    GpioCtrlRegs.GPAPUD.all  &= 0xFFFFFF8B;
    GpioCtrlRegs.GPADIR.all  &= 0xFFFFFF8B;
    EDIS;

    return;
};

Uint16 getSwitches(void){
    volatile Uint16 s = ((GpioDataRegs.GPADAT.all & 0x00000070) >> 3| GpioDataRegs.GPADAT.bit.GPIO2) & 0x000F;
    return s;

}


void setLEDS(Uint16 newLEDVal){
    newLEDVal = ~newLEDVal;
    volatile Uint32 led = (GpioDataRegs.GPADAT.all & 0xFFFF807F) | (newLEDVal << 7);
    GpioDataRegs.GPADAT.all = led;
    return;

}
