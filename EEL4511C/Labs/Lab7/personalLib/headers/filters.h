//  File:   filters.h
//  Date:   03/25/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef FILTERS_H_
#define FILTERS_H_

// Filter constants.
#define FILTER_TAP_NUM_FIR_LPF              43
#define FILTER_TAP_NUM_FIR_BPF              207
#define FILTER_TAP_NUM_FIR_HPF              33

#define FILTER_IIR_SOS_COLUMNS              6
#define FILTER_IIR_LPF_NUM_CASCADED_STAGES  3
#define FILTER_IIR_BPF_NUM_CASCADED_STAGES  6
#define FILTER_IIR_HPF_NUM_CASCADED_STAGES  3

#define PAST_Y_BUFFER_LEN                   16
#define PAST_Y_BUFFER_OFFSER                PAST_Y_BUFFER_LEN/2

// Filter coefficient arrays
extern float lpfFirWeights[FILTER_TAP_NUM_FIR_LPF];

extern float bpfFirWeights[FILTER_TAP_NUM_FIR_BPF];

extern float hpfFirWeights[FILTER_TAP_NUM_FIR_HPF];

extern float lpfIirWeights[FILTER_IIR_LPF_NUM_CASCADED_STAGES][FILTER_IIR_SOS_COLUMNS];

extern float bpfIirWeights[FILTER_IIR_BPF_NUM_CASCADED_STAGES][FILTER_IIR_SOS_COLUMNS];

extern float hpfIirWeights[FILTER_IIR_HPF_NUM_CASCADED_STAGES][FILTER_IIR_SOS_COLUMNS];

// Filter function prototypes.
void initWeights(float* weights, Uint16 len, float scaler);

float firC(float* weights, float* samples, Uint16 weightLen);

float firASM(float* weights, float* samples, Uint16 weightLen);

float iirLpf(Uint16 numCascades, Uint16 numColumns, float weights[][numColumns], float* samples);

float iirBpf(Uint16 numCascades, Uint16 numColumns, float weights[][numColumns], float* samples);

float iirASM(float* weights, float* samples, Uint16 weightLen);

#endif
