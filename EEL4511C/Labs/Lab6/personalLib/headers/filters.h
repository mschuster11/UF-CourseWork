//  File:   filters.h
//  Date:   03/25/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef FILTERS_H_
#define FILTERS_H_

void initLpfWeights(float* weights, Uint16 len, Uint16 scaler);

float lpf(float* weights, float* samples);

float hpf(float* weights, Uint16* samples);

float bpf(float* weights, Uint16* samples);

float lpfASM(float* weights, int16* samples);

#define FILTER_TAP_NUM 45

extern float lpfWeights[FILTER_TAP_NUM];

#endif
