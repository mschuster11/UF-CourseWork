//  File:   filters.h
//  Date:   03/25/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef FILTERS_H_
#define FILTERS_H_

void initLpfWeights(float* weights, Uint16 len, Uint16 scaler);

float lpf(float* weights, Uint16 sampleOffset);

float hpf(float* weights, Uint16* samples);

float bpf(float* weights, Uint16* samples);

float lpfASM(float* weights, Uint16* samples, Uint16 sampleOffset);

/*

FIR filter designed with
http://t-filter.appspot.com

sampling frequency: 48000 Hz

* 0 Hz - 1400 Hz
  gain = 1
  desired ripple = 3 dB
  actual ripple = 0.01957151705898566 dB

* 3000 Hz - 24000 Hz
  gain = 0
  desired attenuation = -40 dB
  actual attenuation = -81.6023105003634 dB

*/

#define FILTER_TAP_NUM 31

extern float lpfWeights[FILTER_TAP_NUM];

#endif
