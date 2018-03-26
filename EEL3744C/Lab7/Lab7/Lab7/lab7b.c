// // Lab 7 part B
// // Name:         Mark L. Schuster
// // Section #:    1540
// // TA Name:      Christopher Crary
// // Description:  Output a sine wave via DAC using 256 samples using DMA.

// #include <avr/io.h>
// #include <avr/interrupt.h>

// #define CLK_PRESCALER	CLK_PSADIV_1_gc

// void INIT_CLK(void);
// void INIT_INTS(void);
// void INIT_ADC(void);
// void INIT_DAC(void);
// void setTimers(void);
// void INIT_DMA(void);

// uint16_t sineLUTData[256] ={
// 0x10,0x20,0x30,0x40,0x50,0x60,0x70,0x80,
// 0x90,0xa0,0xb0,0xc0,0xd0,0xe0,0xf0,0x100,
// 0x110,0x120,0x130,0x140,0x150,0x160,0x170,0x180,
// 0x190,0x1a0,0x1b0,0x1c0,0x1d0,0x1e0,0x1f0,0x200,
// 0x210,0x220,0x230,0x240,0x250,0x260,0x270,0x280,
// 0x290,0x2a0,0x2b0,0x2c0,0x2d0,0x2e0,0x2f0,0x300,
// 0x310,0x320,0x330,0x340,0x350,0x360,0x370,0x380,
// 0x390,0x3a0,0x3b0,0x3c0,0x3d0,0x3e0,0x3f0,0x400,
// 0x410,0x420,0x430,0x440,0x450,0x460,0x470,0x480,
// 0x490,0x4a0,0x4b0,0x4c0,0x4d0,0x4e0,0x4f0,0x500,
// 0x510,0x520,0x530,0x540,0x550,0x560,0x570,0x580,
// 0x590,0x5a0,0x5b0,0x5c0,0x5d0,0x5e0,0x5f0,0x600,
// 0x610,0x620,0x630,0x640,0x650,0x660,0x670,0x680,
// 0x690,0x6a0,0x6b0,0x6c0,0x6d0,0x6e0,0x6f0,0x700,
// 0x710,0x720,0x730,0x740,0x750,0x760,0x770,0x780,
// 0x790,0x7a0,0x7b0,0x7c0,0x7d0,0x7e0,0x7f0,0x800,
// 0x80f,0x81f,0x82f,0x83f,0x84f,0x85f,0x86f,0x87f,
// 0x88f,0x89f,0x8af,0x8bf,0x8cf,0x8df,0x8ef,0x8ff,
// 0x90f,0x91f,0x92f,0x93f,0x94f,0x95f,0x96f,0x97f,
// 0x98f,0x99f,0x9af,0x9bf,0x9cf,0x9df,0x9ef,0x9ff,
// 0xa0f,0xa1f,0xa2f,0xa3f,0xa4f,0xa5f,0xa6f,0xa7f,
// 0xa8f,0xa9f,0xaaf,0xabf,0xacf,0xadf,0xaef,0xaff,
// 0xb0f,0xb1f,0xb2f,0xb3f,0xb4f,0xb5f,0xb6f,0xb7f,
// 0xb8f,0xb9f,0xbaf,0xbbf,0xbcf,0xbdf,0xbef,0xbff,
// 0xc0f,0xc1f,0xc2f,0xc3f,0xc4f,0xc5f,0xc6f,0xc7f,
// 0xc8f,0xc9f,0xcaf,0xcbf,0xccf,0xcdf,0xcef,0xcff,
// 0xd0f,0xd1f,0xd2f,0xd3f,0xd4f,0xd5f,0xd6f,0xd7f,
// 0xd8f,0xd9f,0xdaf,0xdbf,0xdcf,0xddf,0xdef,0xdff,
// 0xe0f,0xe1f,0xe2f,0xe3f,0xe4f,0xe5f,0xe6f,0xe7f,
// 0xe8f,0xe9f,0xeaf,0xebf,0xecf,0xedf,0xeef,0xeff,
// 0xf0f,0xf1f,0xf2f,0xf3f,0xf4f,0xf5f,0xf6f,0xf7f,
// 0xf8f,0xf9f,0xfaf,0xfbf,0xfcf,0xfdf,0xfef,0xfff
// };

// int main(void)
// {
// 	// Init CLK, inturrpts, DAC, DMA, and timers.
// 	INIT_CLK();
// 	INIT_DAC();
// 	INIT_DMA();
// 	setTimers();
// 	INIT_INTS();
	
// 	while (1);
	
// 	return 0;
// }

// /**********************FUNCTIONS***************************************/
// // Subroutine Name: INIT_CLK
// // Init the CLK to 32MHz.
// // Inputs: None
// // Outputs: None
// // Affected: None
// void INIT_CLK(void){
// 	// Enable 32Mhz CLK.
// 	OSC_CTRL = OSC_RC32MEN_bm;

// 	// Wait for 32Mhz flag to be set.
// 	while( !(OSC_STATUS & OSC_RC32MRDY_bm) );

// 	// Write to restriction register to allow writing
// 	// to the CLK CTRL, then sel the 32MHz CLK.
// 	CPU_CCP = CCP_IOREG_gc;
// 	CLK_CTRL = CLK_SCLKSEL_RC32M_gc;

// 	// Write to restriction register to allow writing
// 	// to the CLK PSCTRL, then set the prescaler.
// 	CPU_CCP = CCP_IOREG_gc;
// 	CLK_PSCTRL = CLK_PRESCALER;

// 	return;
// }

// /**********************FUNCTIONS***************************************/
// // Subroutine Name: INIT_INTS
// // Init interrupts.
// // Inputs: None
// // Outputs: None
// // Affected: None
// void INIT_INTS(void){
// 	// Set the PMIC to enable low level interrupts.
// 	PMIC_CTRL = PMIC_LOLVLEN_bm;
	
// 	// Set the interrupt enable bit.
// 	CPU_SREG |= 0x80;

// 	return;
// }


// /**********************FUNCTIONS***************************************/
// // Subroutine Name: INIT_DAC
// // Init the DAC.
// // Inputs: None
// // Outputs: None
// // Affected: None
// void INIT_DAC(void){
// 	// Set the direction of the DAC output.
// 	PORTA_DIRSET = 0x08;
	
// 	// Set to single channel mode.
// 	DACA.CTRLB = DAC_CHSEL0_bm; // Header conflicts with doc3881. This value enables channel 1.
	
// 	// Set PortB as the external reference.
// 	DACA.CTRLC = 0b00011000;
	
// 	// Set the persistent data for 0.7V out.
// 	DACA.CH1DATA= 0x0000;
	
// 	// Enable channel 0 and the DAC.
// 	DACA.CTRLA = (DAC_CH1EN_bm | DAC_ENABLE_bm);
	
// 	return;
// }


// /**********************FUNCTIONS***************************************/
// // Subroutine Name: INIT_DMA
// // Init DMA.
// // Inputs: None
// // Outputs: None
// // Affected: None
// void INIT_DMA(void){
	
// 	DMA.CTRL = 0;
// 	DMA.CTRL = DMA_RESET_bm;
// 	while ((DMA.CTRL & DMA_RESET_bm) != 0);
	
// 	DMA.CTRL			= DMA_ENABLE_bm;
// 	DMA.CH0.CTRLA		= DMA_CH_ENABLE_bm | DMA_CH_BURSTLEN0_bm | DMA_CH_REPEAT_bm | DMA_CH_SINGLE_bm	;
// 	DMA.CH0.ADDRCTRL	= DMA_CH_SRCRELOAD_BLOCK_gc | DMA_CH_SRCDIR_INC_gc | DMA_CH_DESTRELOAD_BURST_gc | DMA_CH_DESTDIR_INC_gc;
// 	DMA.CH0.TRIGSRC		= DMA_CH_TRIGSRC_TCC0_OVF_gc;
// 	DMA.CH0.TRFCNT		= 512;	// Sample num * bytes per smaple.
// 	DMA.CH0.REPCNT		= 0x00; // Repeat endlessly.
// 	DMA.CH0.SRCADDR0	= ( (uint16_t) &sineLUTData[0]) >> 0;
// 	DMA.CH0.SRCADDR1	= ( (uint16_t) &sineLUTData[0]) >> 8;
// 	DMA.CH0.SRCADDR2	= 0x00;
// 	DMA.CH0.DESTADDR0	= (( (uint16_t) &DACA.CH1DATA) >> 0) &0xFF;
// 	DMA.CH0.DESTADDR1	=  ( (uint16_t) &DACA.CH1DATA) >> 8;
// 	DMA.CH0.DESTADDR2	= 0x00;
	
// 	return;
// }


// /**********************FUNCTIONS***************************************/
// // Subroutine Name: setTimers
// // Used to created a delay.
// // Inputs: None
// // Outputs: None
// // Affected: None
// void setTimers(void){
	
// 	//Set the period.
// 	TCC0_PER = 213;
	
// 	// Enable the interrupt and then the timer.
// 	TCC0_INTCTRLA = TC_OVFINTLVL_LO_gc;
	
// 	// Set a prescaler of 2 for greater accuracy.
// 	TCC0_CTRLA = TC_CLKSEL_DIV2_gc;

// 	return;
// }


// /*********************INTERUPT****************************************/
// // Sets up an interrupt to be triggered by TCC0 being overflown.
// // Inputs: None
// // Outputs: None
// // Affected: None
// ISR(TCC0_OVF_vect)
// {
// 	return;
// }

