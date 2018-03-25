//  File:   Codec_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"
#include "Codec_Utils.h"
#include "Interrupt_ISRs.h"

void initCodec(void){
	EALLOW;
    PieVectTable.MRINTB = audioIsr; //link it to my interrupt
    PieCtrlRegs.PIEIER6.bit.INTx3 = 1;
    IER |= M_INT6;
    EDIS;
}
