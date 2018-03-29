//  File:   Interrupt_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"

void initInterrupts(void){
    InitPieCtrl();
    InitPieVectTable();
    EnableInterrupts();

}


