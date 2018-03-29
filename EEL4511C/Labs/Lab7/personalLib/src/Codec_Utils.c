//  File:   Codec_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"

void initCodec(void){
	EALLOW;
    PieVectTable.MRINTB = audioIsr; //link it to my interrupt
    PieCtrlRegs.PIEIER6.bit.INTx3 = 1;
    IER |= M_INT6;
    EnableInterrupts();
    McbspbRegs.SPCR1.bit.RRST = 0;
    McbspbRegs.SPCR1.bit.RRST = 1;
    EDIS;
}
