//  File:   filters.h
//  Date:   03/25/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef FILTERS_H_
#define FILTERS_H_

void initWeights(float* weights, Uint16 len, float scaler);

float firC(float* weights, float* samples, Uint16 weightLen);

float firASM(float* weights, float* samples, Uint16 weightLen);

#define FILTER_TAP_NUM_LPF 43
#define FILTER_TAP_NUM_BPF 207
#define FILTER_TAP_NUM_HPF 33

extern float lpfWeights[FILTER_TAP_NUM_LPF];

extern float bpfWeights[FILTER_TAP_NUM_BPF];

extern float hpfWeights[FILTER_TAP_NUM_HPF];

#endif
