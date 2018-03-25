//  File:   Interrupt_ISRs.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"
#include "Interrupt_ISRs.h"
#include "I2C_LCD_Utils.h"

interrupt void timer1Isr(){
    CpuTimer1Regs.TCR.bit.TIF = 1;
    double voltage = AdcMirror.ADCRESULT0;
    voltage *= (3.0/4096.0);
    voltage *= 100.0;
    Uint16 voltageOnes = (Uint16)voltage / 100;
    Uint16 voltageTenths = ((Uint16)voltage / 10) - voltageOnes*10;
    Uint16 voltageHunths = (Uint16)voltage - voltageOnes*100 - voltageTenths*10;
    cursorHomeLCD();
    sendStringLCD("Voltmeter=");
    sendCharLCD(voltageOnes+'0');
    sendCharLCD('.');
    sendCharLCD(voltageTenths+'0');
    sendCharLCD(voltageHunths+'0');
    sendCharLCD('V');

    return;
}


interrupt void audioIsr(void){
    enum{LEFT, RIGHT,};
    static Uint16 state = LEFT;
    if(state == LEFT){
        McbspbRegs.DXR1.all = McbspbRegs.DRR1.all;
        McbspbRegs.DXR2.all = McbspbRegs.DRR2.all;
        state = RIGHT;
    }
    else if(state == RIGHT)
    {
       McbspbRegs.DXR1.all = McbspbRegs.DRR1.all;
       McbspbRegs.DXR2.all = McbspbRegs.DRR2.all;
       state = LEFT;
    }
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP6;
}
