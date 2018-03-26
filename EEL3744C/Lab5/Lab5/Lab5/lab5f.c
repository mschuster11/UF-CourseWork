// // Lab 5 part F
// // Name:         Mark L. Schuster
// // Section #:    1540
// // TA Name:      Christopher Crary
// // Description:  Play a waveform out of the speaker.

// #include <avr/io.h>
// #include <avr/interrupt.h>

// #define CLK_PRESCALER	CLK_PSADIV_1_gc

// void INIT_CLK(void);
// void INIT_INTS(void);
// void INIT_ADC(void);
// void INIT_DAC(void);
// void DELAY(void);


// int main(void)
// {
// 	// Init CLK, pin dir, and ADC.
// 	INIT_CLK();
// 	INIT_INTS();
// 	INIT_ADC();
// 	INIT_DAC();
// 	DELAY();
// 	// Set the direction of the DAC output.
// 	PORTA_DIRCLR = 0xE0;
// 	PORTA_DIRSET = 0x0C;
// 	PORTC_DIRSET = 0x81;
// 	PORTC_OUTSET = 0x80;
	
	
// 	// Init the DAC.
// 	INIT_DAC();


// 	while (1);
	

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
// 	ADCA_CTRLB = ADC_RESOLUTION_12BIT_gc | ADC_CONMODE_bm | ADC_FREERUN_bm;

// 	// Set the prescaler to div 512.
// 	//ADCA_PRESCALER = ADC_PRESCALER_DIV512_gc;
// 	ADCA_PRESCALER = ADC_PRESCALER_DIV16_gc;

// 	// Set the input pins to be 1 and 6.
// 	ADCA_CH0_MUXCTRL = ADC_CH_MUXPOS_PIN4_gc | ADC_CH_MUXNEG_PIN5_gc;

// 	// Set the mode to differential voltage with a gain of 1.
// 	ADCA_CH0_CTRL = ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;
	
// 	ADCA_CH0_INTCTRL = ADC_CH_INTLVL_LO_gc;
	
// 	// Enable the ADC.
// 	ADCA_CTRLA = 0x05;

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
// 	DACA.CTRLB = DAC_CHSEL1_bm;
	
// 	// Set PortB as the external reference.
// 	DACA.CTRLC = 0b00011000;
	
// 	// Set the persistent data for 0.7V out.
// 	DACA.CH0DATA= 0x0000;
	
// 	// Enable channel 0 and the DAC.
// 	DACA.CTRLA = (DAC_CH1EN_bm | DAC_ENABLE_bm);

	
// }


// /**********************FUNCTIONS***************************************/
// // Subroutine Name: DELAY
// // Used to created a delay.
// // Inputs: None
// // Outputs: None
// // Affected: None
// void DELAY(void){
	
// 	//Set the period.
// 	//TCC0_PER = 125;
// 	//TCC0_PER = 80;
// 	TCC0_PER = 91;
	
// 	// Enable the interrupt and then the timer.
// 	TCC0_INTCTRLA = TC_OVFINTLVL_LO_gc;
// 	TCC0_CTRLA = TC_CLKSEL_DIV8_gc;
// 	//TCC0_CTRLA = TC_CLKSEL_DIV256_gc;
// }


// /*********************INTERUPT****************************************/
// // Sets up an interrupt to be triggered by the completion of channel 0
// // of ADCA.
// // Inputs: None
// // Outputs: None
// // Affected: None
// ISR(ADCA_CH0_vect)
// {
// 	ADCA_CH0_CTRL |=  0x80;

// 	return;
// }

// ISR(TCC0_OVF_vect)
// {
// 	PORTC_OUTTGL = 1;
// 	volatile double resDec = (1.0/820.0)*(ADCA_CH0RES)*(0xFFF/2.5);
// 	if(resDec > 0xFFF)
// 	resDec = 0;
// 	DACA.CH1DATA = resDec;
	
// 	return;
// }


