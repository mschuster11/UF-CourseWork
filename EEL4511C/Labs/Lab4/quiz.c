//  File:   main_Part2.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"
#include "AIC23.h"
#include "InitAIC23.h"
#include "ADC_Utils.h"
#include "Codec_Utils.h"
#include "Interrupt_Utils.h"
#include "I2C_LCD_Utils.h"
#include "Timer1_Utils.h"
#include "Interrupt_ISRs.h"

#define VMAP asm(" CLRC VMAP");

extern volatile double scale;
// Simple enum for bool values.
enum{
    FALSE,
    TRUE,
};


// Function prototypes:

void initSpi(void);

Uint16 main(void)
{
    // Disable the WDT, and init the phase lock loop.
    InitSysCtrl();

    InitMcBSPb();
    InitSPIA();
    InitAIC23();

    initCodec();
    EALLOW;
    EnableInterrupts();
    McbspbRegs.SPCR1.bit.RRST = 0;
    McbspbRegs.SPCR1.bit.RRST = 1;
    EDIS;
    initLCD();
    initADC();
    initTimer1();

    while(TRUE);

    return 0;
}



