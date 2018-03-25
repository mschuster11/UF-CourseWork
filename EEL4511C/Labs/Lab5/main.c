//  File:   main.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"
#include "AIC23.h"
#include "InitAIC23.h"
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
    initExtSRAM();
    setLEDS(0x00);

    /* --- PART 2 --- */
//    SpiTransmit(CLKsampleratecontrol(SR8));
//    SpiTransmit(CLKsampleratecontrol(SR32));


    /* --- PART 3.1 & PART 3.4 --- */
//    SpiTransmit(CLKsampleratecontrol(SR48));

    /* --- PART 3.2 --- */
//    SpiTransmit(CLKsampleratecontrol(SR32));
    audioState = REC_48;

    /* --- QUIZ --- */
    SpiTransmit(CLKsampleratecontrol(SR48));
    while(TRUE)
    {
        /* --- PART 1 ---
        if( !(getSwitches() & 2) && !(getSwitches() & 1) )
            audioState = REC;
        else if( !(getSwitches() & 2) && (getSwitches() & 1) )
                    audioState = MIX;
        else if( (getSwitches() & 2) && !(getSwitches() & 1) )
                    audioState = PLAY;
        else if( (getSwitches() & 2) && (getSwitches() & 1) )
                    audioState = IDLE;
        */

        /* --- PART 3.1 ---
        if( !(getSwitches() & 1)  && audioState != REC_48)
        {
            SpiTransmit(CLKsampleratecontrol(SR8));
        }
        else if( (getSwitches() & 1)  && audioState != REC_48)
        {
            SpiTransmit(CLKsampleratecontrol(SR32));
        }
        */

        /* --- PART 3.2 & PART 3.3 --- */
        static Uint16 set = 32;
        if( !(getSwitches() & 1)  && audioState != REC_48)
        {

            if(set == 32)
            {
                SpiTransmit(CLKsampleratecontrol(SR8));
                set = 8;
            }
        }
        else if( (getSwitches() & 1)  && audioState != REC_48)
        {
            if(set == 8)
            {
                SpiTransmit(CLKsampleratecontrol(SR32));
                set = 32;
            }
        }


        /* --- PART 3.4 --- */


    }
    return 0;
}





