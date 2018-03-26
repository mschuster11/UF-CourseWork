// Lab 5 part C
// Name:         Mark L. Schuster
// Section #:    1540
// TA Name:      Christopher Crary
// Description:  

#include <avr/io.h>
#include <avr/interrupt.h>

#define CLK_PRESCALER	CLK_PSADIV_1_gc

void INIT_CLK(void);
void INIT_DAC(void);
volatile uint16_t cnt = 0;
int main(void)
{
	// Init CLK, pin dir, and ADC.
	INIT_CLK();
	
	// Init the DAC.
	INIT_DAC();


	while (1){
		if(DACA_STATUS & 0x02){
			DACA.CH1DATA = 0x400;

			
		}
	}
	
}

/**********************FUNCTIONS***************************************/
// Subroutine Name: INIT_CLK
// Init the CLK to 32MHz.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_CLK(void){
	// Enable 32Mhz CLK.
	OSC_CTRL = OSC_RC32MEN_bm;

	// Wait for 32Mhz flag to be set.
	while( !(OSC_STATUS & OSC_RC32MRDY_bm) );

	// Write to restriction register to allow writing
	// to the CLK CTRL, then sel the 32MHz CLK.
	CPU_CCP = CCP_IOREG_gc;
	CLK_CTRL = CLK_SCLKSEL_RC32M_gc;

	// Write to restriction register to allow writing
	// to the CLK PSCTRL, then set the prescaler.
	CPU_CCP = CCP_IOREG_gc;
	CLK_PSCTRL = CLK_PRESCALER;
}

/**********************FUNCTIONS***************************************/
// Subroutine Name: INIT_DAC
// Init the DAC.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_DAC(void){
	// Set the direction of the DAC output.
	PORTA_DIRSET = 0x08;
	
	// Set to single channel mode.
	DACA.CTRLB = DAC_CHSEL0_bm;
	
	// Set PortB as the external reference.
	DACA.CTRLC = 0b00011000;
	
	// Set the persistent data for 0.7V out.
	DACA.CH1DATA= 0x0000;
	
	// Enable channel 0 and the DAC.
	DACA.CTRLA = (DAC_CH1EN_bm | DAC_ENABLE_bm);

	
}