//  File:   Interrupt_ISRs.h
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef INTERRUPTISRS_H_
#define INTERRUPTISRS_H_



interrupt void timer1Isr(void);
interrupt void audioIsr(void);


extern Uint16 dataReady;
#endif
