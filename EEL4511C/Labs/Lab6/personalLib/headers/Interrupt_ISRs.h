//  File:   Interrupt_ISRs.h
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef INTERRUPTISRS_H_
#define INTERRUPTISRS_H_

enum{
    REC,
    MIX,
    PLAY,
    IDLE,
};

enum{
    REC_48,
    PLAY_8,
    PLAY_32,
    PLAY_48,
};


interrupt void timer1Isr(void);
interrupt void audioIsr(void);

#endif
