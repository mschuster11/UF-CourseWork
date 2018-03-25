//  File:   extSram.h
//  Date:   03/08/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef EXTSRAM_H_
#define EXTSRAM_H_
#define SRAM_START 0
#define SRAM_END 0x3ffff
extern Uint16 sram[0x40000];

void initExtSRAM(void);

#endif
