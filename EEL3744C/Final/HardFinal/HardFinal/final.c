// Final
// Name:         Mark L. Schuster
// Section #:    1540
// TA Name:      Christopher Crary
// Description:  Input a sinusiod via the ADC then
//				 output it via the DAC. Control with UART.

#include <avr/io.h>
#include <avr/interrupt.h>

#define CLK_PRESCALER	CLK_PSADIV_1_gc
#define TCC_BASE_PER 652
void INIT_CLK(void);
void INIT_INTS(void);
void INIT_ADC(void);
void INIT_DAC(void);
void DELAY(void);
void INIT_USART(void);


static char input = '0';
static uint8_t state = 0;
int main(void)
{
	// Init CLK, pin dir, and ADC.
	INIT_CLK();
	INIT_USART();
	INIT_INTS();
	INIT_ADC();
	INIT_DAC();
	DELAY();
	// Set the direction of the DAC output.
	PORTA_DIRCLR = 0xE0;
	PORTA_DIRSET = 0x05;


	
	
	// Init the DAC.
	INIT_DAC();
		

	while (1){


		
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
// Subroutine Name: INIT_INTS
// Init interrupts.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_INTS(void){
	// Set the PMIC to enable low level interrupts.
	PMIC_CTRL = PMIC_LOLVLEN_bm | PMIC_HILVLEN_bm;
	
	// Set the interrupt enable bit.
	CPU_SREG |= 0x80;
}


/**********************FUNCTIONS***************************************/
// Subroutine Name: INIT_ADC
// Init the ADCA.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_ADC(void){
	// Set the ADC's reference to AREFB.
	ADCA_REFCTRL = ADC_REFSEL_AREFB_gc;

	// Set the res to 8-bits and signed mode.
	ADCA_CTRLB = ADC_RESOLUTION_12BIT_gc | ADC_CONMODE_bm | ADC_FREERUN_bm;

	// Set the prescaler to div 512.
	//ADCA_PRESCALER = ADC_PRESCALER_DIV512_gc;
	ADCA_PRESCALER = ADC_PRESCALER_DIV32_gc;

	// Set the input pins to be 1 and 6.
	ADCA_CH0_MUXCTRL = ADC_CH_MUXPOS_PIN4_gc | ADC_CH_MUXNEG_PIN5_gc;

	// Set the mode to differential voltage with a gain of 1.
	ADCA_CH0_CTRL = ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_DIFFWGAIN_gc;
	
	ADCA_CH0_INTCTRL = ADC_CH_INTLVL_LO_gc;
	
	// Enable the ADC.
	ADCA_CTRLA = 0x05;

}

/**********************FUNCTIONS***************************************/
// Subroutine Name: INIT_DAC
// Init the DAC.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_DAC(void){
	// Set the direction of the DAC output.
	PORTA_DIRSET = 0x04;
	
	// Set to single channel mode.
	DACA.CTRLB = 0;
	
	// Set PortB as the external reference.
	DACA.CTRLC = 0b00011000;
	
	// Set the persistent data for 0.7V out.
	DACA.CH0DATA= 0x0000;
	
	// Enable channel 0 and the DAC.
	DACA.CTRLA = (DAC_CH0EN_bm | DAC_ENABLE_bm);

	
}


/**********************FUNCTIONS***************************************/
// Subroutine Name: DELAY
// Used to created a delay.
// Inputs: None
// Outputs: None
// Affected: None
void DELAY(void){
	
	//Set the period.
	//TCC0_PER = 125;
	TCC0_PER = TCC_BASE_PER;
	
	// Enable the interrupt and then the timer.
	TCC0_INTCTRLA = TC_OVFINTLVL_LO_gc;
	TCC0_CTRLA = TC_CLKSEL_DIV1_gc;
	//TCC0_CTRLA = TC_CLKSEL_DIV256_gc;
}

/*********************FUNCTIONS**************************************/
// Subroutine Name: INIT_USART
// Init the USART regs.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_USART(void){
	// Set the direction of the Tx & Rx pins.
	PORTD_DIRSET = USART_TXEN_bm;
	PORTD_DIRCLR = USART_RXEN_bm;
	
	// Set the baud rate.
	USARTD0_BAUDCTRLA = 0xF5;
	USARTD0_BAUDCTRLB = 0xCC;
	
	// Set the data size and the mode.
	USARTD0_CTRLC = USART_CHSIZE_8BIT_gc;
	USARTD0_CTRLB = 0b00011000;
	
	USARTD0_CTRLA = USART_RXCINTLVL_HI_gc;

	return;
}

/*********************INTERUPT****************************************/
// Sets up an interrupt to be triggered by the completion of channel 0
// of ADCA.
// Inputs: None
// Outputs: None
// Affected: None
ISR(ADCA_CH0_vect)
{
	ADCA_CH0_CTRL |=  0x80;

	return;
}

ISR(TCC0_OVF_vect)
{
	PORTA_OUTTGL = 1;
	double resDec = (1.0/820.0)*(ADCA_CH0RES)*(0xFFF/2.5);
	if(resDec > 0xFFF)
		resDec = 0;
	if(state == 0)
		DACA.CH0DATA = resDec;
	else if(state == 1)
		DACA.CH0DATA = resDec/2;
	else if(state == 2)
		DACA.CH0DATA = resDec*2;
	return;
}

/*********************INTERUPT****************************************/
// Sets up an interrupt to be triggered by a character being 
// over UART. 
// Inputs: None
// Outputs: None
// Affected: TCC1_CNT, input
ISR(USARTD0_RXC_vect){
	input = USARTD0_DATA;
			if (input == 'd' || input == 'D')
		{
					state = 0;
			input =0;
		}
		else if (input == 'h' || input == 'H')
		{
				state = 1;	
			input =0;
		}
		else if (input == 't' || input == 'T')
		{
				state = 2;	
			input =0;
		}
	return;
}

