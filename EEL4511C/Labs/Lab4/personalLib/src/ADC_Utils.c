//  File:   ADC_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"
#include "I2C_LCD_Utils.h"
#include "ADC_Utils.h"

void initADC(void){
    InitAdc();
    EALLOW;
    PieCtrlRegs.PIEIER1.bit.INTx6 = 1;
    AdcRegs.ADCTRL1.all = 0x0170;
    AdcRegs.ADCCHSELSEQ1.bit.CONV00 = 0;
    AdcRegs.ADCREFSEL.bit.REF_SEL = 0x0;
    AdcRegs.ADCMAXCONV.all = 0;
    AdcRegs.ADCTRL1.bit.CPS = 1;
    AdcRegs.ADCTRL2.bit.SOC_SEQ1 = 1;

    return;
}
