// Lab 6 part G
// Name:         Mark L. Schuster
// Section #:    1540
// TA Name:      Christopher Crary
// Description:

#include <avr/io.h>
#include <avr/interrupt.h>
#include "roboticsBackPack.h"
#include "LSM330.h"

#define CLK_PRESCALER	CLK_PSADIV_1_gc

typedef enum{
	FALSE,
	TRUE
}bool;

void INIT_CLK(void);
void INIT_RGB(void);
void INIT_INTS(void);
void setRGB(uint16_t, uint16_t, uint16_t);


volatile bool accelDataReady = FALSE;



int main(void)
{
	// Init CLK, pin dir, and ADC.
	volatile uint16_t accelXData;
	volatile uint16_t accelYData;
	volatile uint16_t accelZData;

	INIT_CLK();
	INIT_RGB();
	INIT_INTS();
	accel_init();
	
	while (1){
		if(accelDataReady){
			uint8_t accelXLData = accelRead(OUT_X_L_A);
			uint8_t accelXHData = accelRead(OUT_X_H_A);
			accelXData = (accelXHData << 8) | accelXLData;
			uint8_t accelYLData = accelRead(OUT_Y_L_A);
			uint8_t accelYHData = accelRead(OUT_Y_H_A);
			accelYData = (accelYHData << 8) | accelYLData;
			uint8_t accelZLData = accelRead(OUT_Z_L_A);
			uint8_t accelZHData = accelRead(OUT_Z_H_A);
			accelZData = (accelZHData << 8) | accelZLData;
			accelXData =  (accelXData < 0) ? (0-accelXData) : accelXData;
			accelYData =  (accelYData < 0) ? (0-accelYData) : accelYData;
			accelZData =  (accelZData < 0) ? (0-accelZData) : accelZData;

			setRGB(accelXData, accelYData, accelZData);
			accelDataReady = FALSE;
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
// Subroutine Name: INIT_RGB
// Init the RGB LED.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_RGB(void){
	PORTD_DIRSET 	= 0b01110000;
	PORTD_REMAP  	= 0b00000111;
	
	// Value to set the prescaler of the TC to be 1 times the sys CLK.
	TCD0_CTRLA   	= 0b00000001;
	
	// Sets the PWM mode of the TC to single slope.
	TCD0_CTRLB 		= 0b01110011;
	TCD0_PER		= 0xFFFF;
	PORTD_OUTSET	= 0x00;

}


/**********************FUNCTIONS***************************************/
// Subroutine Name: setRGB
// Sets the value of the RGB LED. 
// Inputs: None
// Outputs: None
// Affected: None
void setRGB(uint16_t redVal, uint16_t greenVal, uint16_t blueVal){
	TCD0_CCA = ~redVal;
	TCD0_CCB = ~greenVal;
	TCD0_CCC = ~blueVal;
}

/**********************FUNCTIONS***************************************/
// Subroutine Name: INIT_INTS
// Init interrupts.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_INTS(void){
	// Set the PMIC to enable low level interrupts.
	PMIC_CTRL = PMIC_LOLVLEN_bm;
	
	// Set the interrupt enable bit.
	CPU_SREG |= 0x80;
}


/*********************INTERUPT****************************************/
// Sets up an interrupt to be triggered by rising edge on port C's pin 7.
//
// Inputs: None
// Outputs: None
// Affected: None
ISR(PORTC_INT0_vect){
	accelDataReady = TRUE;
	return;
}
