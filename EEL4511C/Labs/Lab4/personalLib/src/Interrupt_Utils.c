//  File:   Interrupt_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include <DSP2833x_Device.h>
#include "DSP28x_Project.h"
#include "Interrupt_Utils.h"

void initInterrupts(void){
    InitPieCtrl();
    InitPieVectTable();
    EnableInterrupts();

}
