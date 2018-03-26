//  File:   Timer1_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"

/*

FIR filter designed with
http://t-filter.appspot.com

sampling frequency: 48000 Hz

* 0 Hz - 2300 Hz
  gain = 1
  desired ripple = 3 dB
  actual ripple = 2.324976626092349 dB

* 4000 Hz - 24000 Hz
  gain = 0
  desired attenuation = -40 dB
  actual attenuation = -40.15807023749789 dB

*/



float lpfWeights[FILTER_TAP_NUM] = {
  0.0036701115660588844,
  -0.0032867394844691153,
  -0.005684938056047973,
  -0.009413585771001947,
  -0.013876121682633394,
  -0.018365180370116075,
  -0.022023840071844613,
  -0.023896893417598583,
  -0.023046066874992197,
  -0.018684346005724908,
  -0.010314695177543468,
  0.002150724327631984,
  0.018278112237291144,
  0.03717492821911709,
  0.05748391024813817,
  0.07754868205258766,
  0.09558973345260616,
  0.10990942068504551,
  0.11911796047401012,
  0.12229465091642377,
  0.11911796047401012,
  0.10990942068504551,
  0.09558973345260616,
  0.07754868205258766,
  0.05748391024813817,
  0.03717492821911709,
  0.018278112237291144,
  0.002150724327631984,
  -0.010314695177543468,
  -0.018684346005724908,
  -0.023046066874992197,
  -0.023896893417598583,
  -0.022023840071844613,
  -0.018365180370116075,
  -0.013876121682633394,
  -0.009413585771001947,
  -0.005684938056047973,
  -0.0032867394844691153,
  0.0036701115660588844
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

	return res*10;
}

float hpf(float* weights, Uint16* samples);

float bpf(float* weights, Uint16* samples);

