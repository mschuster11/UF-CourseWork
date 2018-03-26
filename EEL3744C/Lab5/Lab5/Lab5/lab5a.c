// // Lab 5 part A
// // Name:         Mark L. Schuster
// // Section #:    1540
// // TA Name:      Christopher Crary
// // Description:  Using the ADC to test a CdS cell.

// #include <avr/io.h>
// #define CLK_PRESCALER	CLK_PSADIV_1_gc

// void INIT_CLK(void);
// void INIT_ADC(void);


// int main(void)
// {
// 	// Init CLK, pin dir, and ADC.
// 	INIT_CLK();
// 	PORTA_DIRCLR = 0x42;
// 	INIT_ADC();
//     while (1){
// 		// Run ADC and wait until its finished.
// 		ADCA_CH0_CTRL |=  0x80;
// 		while(!ADCA_CH0_INTFLAGS);

// 	}

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
// }

// /**********************FUNCTIONS***************************************/
// // Subroutine Name: INIT_ADC
// // Init the ADCA.
// // Inputs: None
// // Outputs: None
// // Affected: None
// void INIT_ADC(void){
// 	// Set the ADC's reference to AREFB.
// 	ADCA_REFCTRL = ADC_REFSEL_AREFB_gc;

// 	// Set the res to 8-bits and signed mode.
// 	ADCA_CTRLB = ADC_RESOLUTION_8BIT_gc | ADC_CONMODE_bm | ADC_FREERUN_bm;

// 	// Set the prescaler to div 512.
// 	ADCA_PRESCALER = ADC_PRESCALER_DIV512_gc;

// 	// Set the input pins to be 1 and 6.
// 	ADCA_CH0_MUXCTRL = ADC_CH_MUXPOS_PIN1_gc | ADC_CH_MUXNEG_PIN6_gc;

// 	// Set the mode to differential voltage with a gain of 1.
// 	ADCA_CH0_CTRL = ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_DIFFWGAIN_gc;
	
// 	ADCA_CH0_INTCTRL = ADC_CH_INTLVL_LO_gc;
	
// 	// Enable the ADC.
// 	ADCA_CTRLA = 0x05;

// }





