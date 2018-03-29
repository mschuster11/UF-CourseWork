//  File:   Interrupt_ISRs.h
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef INTERRUPTISRS_H_
#define INTERRUPTISRS_H_
#define SAMPLE_BUFFER_SIZE          512
#define SAMPLE_BUFFER_OFFSET        SAMPLE_BUFFER_SIZE/2
#define SAMPLE_BUFFER_MASK_ON       0xFF00
#define SAMPLE_BUFFER_MASK_OFF      0x00FF

interrupt void timer1Isr(void);
interrupt void audioIsr(void);

extern float sampleBuffer[SAMPLE_BUFFER_SIZE];
extern Uint16 dataReady;
#endif
