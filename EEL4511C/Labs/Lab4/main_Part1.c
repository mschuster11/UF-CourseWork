//  File:   main_Part1.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"

#include "ADC_Utils.h"
#include "Interrupt_Utils.h"
#include "I2C_LCD_Utils.h"
#include "Timer1_Utils.h"
#include "Interrupt_ISRs.h"

// Simple enum for bool values.
enum{
    FALSE,
    TRUE,
};


// Function prototypes:


void initLEDSAndSwitches(void);

Uint16 main(void)
{
    // Disable the WDT, and init the phase lock loop.
    DisableDog();
    InitPll(10,3);

    initLEDSAndSwitches();
    initLCD();
    initADC();
    initInterrupts();
    initTimer1();

    while(TRUE);
    return 0;
}


void initLEDSAndSwitches(void){
    // Allow write to protected regs.
    EALLOW;
    GpioCtrlRegs.GPAMUX1.all &= 0x0003FFF0;
    GpioCtrlRegs.GPADIR.all  |= 0x00007F80;
    GpioCtrlRegs.GPAMUX1.all &= 0xFFFFF30F;
    GpioCtrlRegs.GPAPUD.all  &= 0xFFFFFF8B;
    GpioCtrlRegs.GPADIR.all  &= 0xFFFFFF8B;

    return;
};



