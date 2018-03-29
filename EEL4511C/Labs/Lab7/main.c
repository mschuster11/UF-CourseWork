//  File:   main.c
//  Date:   03/28/201
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"
#include <AIC23.h>
#include <InitAIC23.h>
#include "msLib.h"

extern Uint16 audioState;
// Simple enum for bool values.
enum{
    FALSE,
    TRUE,
};

// Function prototypes:

Uint16 main(void)
{
    // Disable the WDT, and init the phase lock loop.
    InitSysCtrl();
    initLEDSAndSwitches();
    InitMcBSPb();
    InitSPIA();
    InitAIC23();
    initCodec();
    setLEDS(0x00);

    SpiTransmit(CLKsampleratecontrol(SR48));
//    initWeights(lpfWeights, FILTER_TAP_NUM_FIR_LPF, 10.0);
//    initWeights(bpfWeights, FILTER_TAP_NUM_FIR_BPF, 20.0);
//    initWeights(hpfFirWeights, FILTER_TAP_NUM_FIR_HPF, 10.0);
    for(;;);
}





