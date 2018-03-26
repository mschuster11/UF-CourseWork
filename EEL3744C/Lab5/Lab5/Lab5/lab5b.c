// // Lab 5 part B
// // Name:         Mark L. Schuster
// // Section #:    1540
// // TA Name:      Christopher Crary
// // Description:  Using the ADC to test a CdS cell and 
// //				 output the measurements via serial.

// #include <avr/io.h>
// #include <avr/interrupt.h>

// #define CLK_PRESCALER	CLK_PSADIV_1_gc

// void INIT_CLK(void);
// void INIT_INTS(void);
// void INIT_ADC(void);
// void INIT_USART(void);
// void OUT_CHAR(char);
// void OUT_STRING(char*);
// void OUT_STRINGLN(char*);
// void OUT_STRINGPG(char*);

// int main(void)
// {
// 	// Init CLK, pin dir, and ADC.
// 	INIT_CLK();
// 	INIT_INTS();
// 	PORTA_DIRCLR = 0x42;
// 	INIT_ADC();
// 	INIT_USART();

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

// /**********************FUNCTIONS***************************************/
// // Subroutine Name: INIT_USART
// // Init the USART regs.
// // Inputs: None
// // Outputs: None
// // Affected: None
// void INIT_USART(void){
// 	// Set the direction of the Tx & Rx pins.
// 	PORTD_DIRSET = USART_TXEN_bm;
// 	PORTD_DIRCLR = USART_RXEN_bm;
	
// 	// Set the baud rate.
// 	USARTD0_BAUDCTRLA = 1;
// 	USARTD0_BAUDCTRLB = 0;
	
// 	// Set the data size and the mode.
// 	USARTD0_CTRLC = USART_CHSIZE_8BIT_gc;
// 	USARTD0_CTRLB = 0b00011000;
// }


// /**********************FUNCTIONS***************************************/
// // Subroutine Name: OUT_CHAR
// // Send a char over USART.
// // Inputs: char c = input char
// // Outputs: None
// // Affected: None
// void OUT_CHAR(char c){
// 	// Wait for the data buffer to be ready for
// 	// input, load the character, finally wait until 
// 	// transmission is complete.
// 	while(!(USARTD0_STATUS & USART_DREIF_bm));
// 	USARTD0_DATA = c;
// 	while(!(USARTD0_STATUS & USART_TXCIF_bm));
	
// 	return;
// }

// /**********************FUNCTIONS***************************************/
// // Subroutine Name: OUT_STRING
// // Send a string over USART.
// // Inputs: char* s = input string
// // Outputs: None
// // Affected: None
// void OUT_STRING(char* s){
// 	// Wait for the data buffer to be ready for
// 	// input, load the character, finally wait until 
// 	// transmission is complete. Loop until the
// 	// NULL terminator is reached.
// 	for(uint8_t i=0; s[i]!='\0'; i++){
// 		while(!(USARTD0_STATUS & USART_DREIF_bm));
// 		USARTD0_DATA = s[i];
// 		while(!(USARTD0_STATUS & USART_TXCIF_bm));
// 	}
	
// 	return;
// }


// /**********************FUNCTIONS***************************************/
// // Subroutine Name: OUT_STRINGLN
// // Send a string over USART with a new line.
// // Inputs: char* s = input string
// // Outputs: None
// // Affected: None
// void OUT_STRINGLN(char* s){
// 	// Print the string, then set a new line.
// 	OUT_STRING(s);
// 	OUT_CHAR('\r');
// 	OUT_CHAR('\n');
	
// 	return;
// }

// /**********************FUNCTIONS***************************************/
// // Subroutine Name: OUT_STRINGPG
// // Send a string over USART with a new page.
// // Inputs: char* s = input string
// // Outputs: None
// // Affected: None
// void OUT_STRINGPG(char* s){
// 	// Move to a new page, then print the string.
// 	OUT_CHAR('\f');
// 	OUT_STRING(s);
	
// 	return;
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
// 	volatile uint8_t res = ADCA_CH0RES;
// 	if((res & 0x80)){
// 		res = ~(res--);
// 		OUT_CHAR('-');
// 	}else
// 		OUT_CHAR('+');
// 	volatile double resDec = 0.02*(res-1);
// 	volatile uint8_t resInt1 = (int) resDec;
// 	volatile double resDecTens = 10*(resDec - resInt1);
// 	volatile uint8_t resInt2 = (int) resDecTens;
// 	volatile double resDecOnes = 10*(resDecTens - resInt2);
// 	volatile uint8_t resInt3 = (int) resDecOnes;
// 	OUT_CHAR(resInt1+'0');
// 	OUT_CHAR('.');
// 	OUT_CHAR(resInt2+'0');
// 	OUT_CHAR(resInt3+'0');
// 	OUT_STRING("V (0x");
	
// 	volatile uint8_t resl = (ADCA_CH0RES & 0x0F)+'0';
// 	volatile uint8_t resf = ((ADCA_CH0RES & 0xF0) >> 4)+'0';
// 	if(resf>'9')
// 		resf = (resf-'0')+'A'-10;
		
// 	if(resl>'9')
// 		resl = (resl-'0')+'A'-10;
	
// 	OUT_CHAR(resf);
// 	OUT_CHAR(resl);
// 	OUT_CHAR(')');
// 	OUT_STRINGLN('\0');
	
// 	return;
// }
