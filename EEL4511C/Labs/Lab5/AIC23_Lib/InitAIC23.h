// TI File $Revision:  $
// Checkin $Date:  $
//###########################################################################
//
// FILE:    AIC23.h
//
// TITLE:   TLV320AIC23B Driver Register and Bit Definitions
//
//###########################################################################
// $TI Release:   $
// $Release Date:   $
//###########################################################################

#ifndef _INITAIC_23_H
#define _INITAIC_23_H


void InitMcBSPb();
void InitSPIA();
void InitAIC23();
void SpiTransmit(Uint16 data);

#endif
