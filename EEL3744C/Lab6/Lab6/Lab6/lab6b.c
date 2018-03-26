// // Lab 6 part B
// // Name:         Mark L. Schuster
// // Section #:    1540
// // TA Name:      Christopher Crary
// // Description:  Send 0x53 over spi forever.

// #include <avr/io.h>
// #include "spi.h"
// #define CLK_PRESCALER	CLK_PSADIV_1_gc

// void INIT_CLK(void);
// void INIT_ADC(void);



// int main(void)
// {
// 	// Init CLK, pin dir, and ADC.
// 	INIT_CLK();
// 	spi_init();

// 	while (1){
// 		spiWrite(0x53);

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
