//  File:   Interrupt_ISRs.h
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef INTERRUPTISRS_H_
#define INTERRUPTISRS_H_
#define SAMPLE_BUFFER_SIZE  256
#define SAMPLE_BUFFER_OFFSET  128


interrupt void timer1Isr(void);
interrupt void audioIsr(void);

extern int16 sampleBuffer[SAMPLE_BUFFER_SIZE];
extern Uint16 dataReady;
#endif
