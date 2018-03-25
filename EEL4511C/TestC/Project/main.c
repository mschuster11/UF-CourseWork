#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"

// Simple enum for bool values.
enum{
    FALSE,
    TRUE,
};

// Function prototypes:
void initLEDSAndSwitches(void);

int main(void)
{
    // Disable the WDT.
    DisableDog();

    initLEDSAndSwitches();

    Uint16 s0;
    Uint32 s321, switches, LEDS;
    while(TRUE)
    {
        // Pull s0, s1, s2, and s3.
        s0 =  GpioDataRegs.GPADAT.bit.GPIO2;
        s321 = (GpioDataRegs.GPADAT.all & 0x00000070);

        // Shift s0 so switches are grouped.
        switches = s321 | s0<<3;

        // Clear current LED value.
        LEDS = GpioDataRegs.GPADAT.all & 0x0000807F;

        // Load switch values into LEDs twice.
        LEDS |= (switches << 4) | (switches << 8);
        GpioDataRegs.GPADAT.all = LEDS;

    }

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
