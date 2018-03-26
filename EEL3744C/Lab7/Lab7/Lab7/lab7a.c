// // Lab 7 part A
// // Name:         Mark L. Schuster
// // Section #:    1540
// // TA Name:      Christopher Crary
// // Description:  Output a sine wave from a LUT.

// #include <avr/io.h>
// #include <avr/interrupt.h>

// #define CLK_PRESCALER	CLK_PSADIV_1_gc

// void INIT_CLK(void);
// void INIT_INTS(void);
// void INIT_DAC(void);
// void setTimers(void);

// uint16_t sineLUTData[256] ={
// 	0x800,0x832,0x864,0x896,0x8c8,0x8fa,0x92c,0x95e,
// 	0x98f,0x9c0,0x9f1,0xa22,0xa52,0xa82,0xab1,0xae0,
// 	0xb0f,0xb3d,0xb6b,0xb98,0xbc5,0xbf1,0xc1c,0xc47,
// 	0xc71,0xc9a,0xcc3,0xceb,0xd12,0xd39,0xd5f,0xd83,
// 	0xda7,0xdca,0xded,0xe0e,0xe2e,0xe4e,0xe6c,0xe8a,
// 	0xea6,0xec1,0xedc,0xef5,0xf0d,0xf24,0xf3a,0xf4f,
// 	0xf63,0xf76,0xf87,0xf98,0xfa7,0xfb5,0xfc2,0xfcd,
// 	0xfd8,0xfe1,0xfe9,0xff0,0xff5,0xff9,0xffd,0xffe,
// 	0xfff,0xffe,0xffd,0xff9,0xff5,0xff0,0xfe9,0xfe1,
// 	0xfd8,0xfcd,0xfc2,0xfb5,0xfa7,0xf98,0xf87,0xf76,
// 	0xf63,0xf4f,0xf3a,0xf24,0xf0d,0xef5,0xedc,0xec1,
// 	0xea6,0xe8a,0xe6c,0xe4e,0xe2e,0xe0e,0xded,0xdca,
// 	0xda7,0xd83,0xd5f,0xd39,0xd12,0xceb,0xcc3,0xc9a,
// 	0xc71,0xc47,0xc1c,0xbf1,0xbc5,0xb98,0xb6b,0xb3d,
// 	0xb0f,0xae0,0xab1,0xa82,0xa52,0xa22,0x9f1,0x9c0,
// 	0x98f,0x95e,0x92c,0x8fa,0x8c8,0x896,0x864,0x832,
// 	0x800,0x7cd,0x79b,0x769,0x737,0x705,0x6d3,0x6a1,
// 	0x670,0x63f,0x60e,0x5dd,0x5ad,0x57d,0x54e,0x51f,
// 	0x4f0,0x4c2,0x494,0x467,0x43a,0x40e,0x3e3,0x3b8,
// 	0x38e,0x365,0x33c,0x314,0x2ed,0x2c6,0x2a0,0x27c,
// 	0x258,0x235,0x212,0x1f1,0x1d1,0x1b1,0x193,0x175,
// 	0x159,0x13e,0x123,0x10a,0xf2,0xdb,0xc5,0xb0,
// 	0x9c,0x89,0x78,0x67,0x58,0x4a,0x3d,0x32,
// 	0x27,0x1e,0x16,0xf,0xa,0x6,0x2,0x1,
// 	0x0,0x1,0x2,0x6,0xa,0xf,0x16,0x1e,
// 	0x27,0x32,0x3d,0x4a,0x58,0x67,0x78,0x89,
// 	0x9c,0xb0,0xc5,0xdb,0xf2,0x10a,0x123,0x13e,
// 	0x159,0x175,0x193,0x1b1,0x1d1,0x1f1,0x212,0x235,
// 	0x258,0x27c,0x2a0,0x2c6,0x2ed,0x314,0x33c,0x365,
// 	0x38e,0x3b8,0x3e3,0x40e,0x43a,0x467,0x494,0x4c2,
// 	0x4f0,0x51f,0x54e,0x57d,0x5ad,0x5dd,0x60e,0x63f,
// 	0x670,0x6a1,0x6d3,0x705,0x737,0x769,0x79b,0x7cd,
// };

// int main(void)
// {
// 	// Init CLK, inturrpts, DAC, and timers.
// 	INIT_CLK();
// 	INIT_INTS();
// 	INIT_DAC();
// 	setTimers();

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
// // Subroutine Name: setTimers
// // Inits the timers.
// // Inputs: None
// // Outputs: None
// // Affected: None
// void setTimers(void){
	
// 	//Set the period.
// 	TCC0_PER = 214;
	
// 	// Enable the interrupt and then the timer.
// 	TCC0_INTCTRLA = TC_OVFINTLVL_LO_gc;
	
// 	TCC0_CTRLA = TC_CLKSEL_DIV2_gc;

// 	return;
// }


// /*********************INTERUPT****************************************/
// // Sets up an interrupt to be triggered by TC0 being overflown.
// // Inputs: None
// // Outputs: None
// // Affected: None
// ISR(TCC0_OVF_vect)
// {
// 	static uint8_t index = 0;
	
// 	DACA.CH1DATA = sineLUTData[index++];
	
// 	return;
// }


