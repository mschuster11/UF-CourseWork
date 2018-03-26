//  File:   Timer1_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"

/*

FIR filter designed with
http://t-filter.appspot.com

sampling frequency: 48000 Hz

* 0 Hz - 3300 Hz
  gain = 1
  desired ripple = 3 dB
  actual ripple = 2.306782279841122 dB

* 5500 Hz - 24000 Hz
  gain = 0
  desired attenuation = -40 dB
  actual attenuation = -40.22550807079389 dB

*/

float lpfWeights[FILTER_TAP_NUM] = {
  0.006561822070201617,
  0.002552099972690457,
  -0.0007608321554718212,
  -0.007424071352038155,
  -0.016755571011221177,
  -0.026709121133704244,
  -0.03407279731814723,
  -0.03510095435186803,
  -0.026488589280384247,
  -0.00646234853837211,
  0.02438257091288337,
  0.06278022700745123,
  0.10318009605280441,
  0.1388682846056382,
  0.16338571931654608,
  0.1721128892178053,
  0.16338571931654608,
  0.1388682846056382,
  0.10318009605280441,
  0.06278022700745123,
  0.02438257091288337,
  -0.00646234853837211,
  -0.026488589280384247,
  -0.03510095435186803,
  -0.03407279731814723,
  -0.026709121133704244,
  -0.016755571011221177,
  -0.007424071352038155,
  -0.0007608321554718212,
  0.002552099972690457,
  0.006561822070201617
};


void initLpfWeights(float* weights, Uint16 len, Uint16 scaler)
{
    for(Uint16 i=0;i<len;i++)
        weights[i] = (float)scaler*weights[i];

}

float lpf(float* weights, Uint16 sampleOffset)
{
	float res = 0;
	Uint16 sampleIndex = 0xFFC0|sampleOffset;
	for(int16 i=0;i<FILTER_TAP_NUM; i++)
	    res+=weights[i]*(float)(int16)sram[(sampleIndex-i)&0x003F];

	return res;
}

float hpf(float* weights, Uint16* samples);

float bpf(float* weights, Uint16* samples);

