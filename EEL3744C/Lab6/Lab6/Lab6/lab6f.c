// // Lab 6 part C
// // Name:         Mark L. Schuster
// // Section #:    1540
// // TA Name:      Christopher Crary
// // Description:	 

// #include <avr/io.h>
// #include <avr/interrupt.h>
// #include "roboticsBackPack.h"
// #include "LSM330.h"

// #define CLK_PRESCALER	CLK_PSADIV_1_gc

// typedef enum{
// 	FALSE,
// 	TRUE
// }bool;

// void INIT_CLK(void);
// void INIT_INTS(void);
// void INIT_USART(void);
// void OUT_CHAR(char);
// void OUT_STRING(char*);
// void STREAM_DATA(uint16_t,uint16_t,uint16_t);

// volatile bool accelDataReady = FALSE;



// int main(void)
// {
// 	// Init CLK, pin dir, and ADC.
// 	volatile uint16_t accelXData;
// 	volatile uint16_t accelYData;
// 	volatile uint16_t accelZData;

// 	INIT_CLK();
// 	INIT_USART();
// 	INIT_INTS();
// 	accel_init();

// 	while (1){
// 		if(accelDataReady){
// 			accelXData =	(accelRead(OUT_X_H_A) << 8) | accelRead(OUT_X_L_A);
// 			accelYData =	(accelRead(OUT_Y_H_A) << 8) | accelRead(OUT_Y_L_A);
// 			accelZData =	(accelRead(OUT_Z_H_A) << 8) | accelRead(OUT_Z_L_A);

// 			STREAM_DATA(accelXData, accelYData, accelZData);
// 			accelDataReady = FALSE;
// 		}
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


// ********************FUNCTIONS*************************************
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
// // Subroutine Name: STREAM_DATA
// // Send axis data over UART.
// // Inputs: accelXData, accelYData, accelZData
// // Outputs: None
// // Affected: None
// void STREAM_DATA(uint16_t accelXData, uint16_t accelYData, uint16_t accelZData){
// 	OUT_CHAR(0x03);
// 	OUT_CHAR((uint8_t)(accelXData));
// 	OUT_CHAR((uint8_t)(accelXData >> 8));
// 	OUT_CHAR((uint8_t)(accelYData));
// 	OUT_CHAR((uint8_t)(accelYData >> 8));
// 	OUT_CHAR((uint8_t)(accelZData));
// 	OUT_CHAR((uint8_t)(accelZData >> 8));
// 	OUT_CHAR(0xfc);

// 	return;
// }

// /*********************INTERUPT****************************************/
// // Sets up an interrupt to be triggered by rising edge on port C's pin 7.
// // 
// // Inputs: None
// // Outputs: None
// // Affected: None
// ISR(PORTC_INT0_vect){
// 	accelDataReady = TRUE;
// 	return;
// }
