// roboticsBackpack.c
// Name:         Mark L. Schuster
// Section #:    1540
// TA Name:      Christopher Crary
// Description:	 Definitions of robotics backpack functions.

#include <avr/io.h>
#include "LSM330.h"
#include "spi.h"
#include "roboticsBackpack.h"

/**********************FUNCTIONS***************************************/
// Subroutine Name: accel_init
// Init the accelerometer.
// Inputs: None
// Outputs: None
// Affected: None
void accel_init(void){
	PORTA_DIRSET = RBB_PROTOCOL_SEL;
	PORTA_OUTCLR = RBB_PROTOCOL_SEL;
	PORTF_OUTSET = RBB_SSA | RBB_SSG | RBB_SENSOR_SEL_ACCEl_bp;
	spi_init();
	accelWrite(CTRL_REG4_A, CTRL_REG4_A_STRT);
	PORTC_DIRCLR = RBB_INT1A;
	PORTC_PIN7CTRL = PORT_ISC_FALLING_gc;
	PORTC_INT0MASK = RBB_INT1A;
	PORTC_INTCTRL = PORT_INT0LVL_LO_gc;
	uint8_t reg4AInitData = CTRL_REG4_A_DR_EN | CTRL_REG4_A_IEA | CTRL_REG4_A_INT1_EN;
	accelWrite(CTRL_REG4_A, reg4AInitData);
	uint8_t reg5AInitData = CTRL_REG5_A_ODR3 | CTRL_REG5_A_ODR0 | CTRL_REG5_A_ZEN | CTRL_REG5_A_YEN | CTRL_REG5_A_XEN;
	accelWrite(CTRL_REG5_A, reg5AInitData);


}

/**********************FUNCTIONS***************************************/
// Subroutine Name: accelRead
// Read a byte from the accelerometer.
// Inputs: None
// Outputs: Byte read from accelerometer.
// Affected: None
uint8_t accelRead(uint8_t targetReg){
	uint8_t spiVal = 0x80 | targetReg;
	uint8_t result;
	PORTF_OUTCLR = RBB_SSA;
	spiWrite(spiVal);
	result = spiRead();
	PORTF_OUTSET = RBB_SSA;
	return result;
}

/**********************FUNCTIONS***************************************/
// Subroutine Name: accelWrite
// Write a byte to the accelerometer.
// Inputs: Byte to be written.
// Outputs: None
// Affected: None
void accelWrite(uint8_t targetReg, uint8_t data){
	uint8_t spiVal = 0x00 | targetReg;
	PORTF_OUTCLR = RBB_SSA;
	spiWrite(spiVal);
	spiWrite(data);
	PORTF_OUTSET = RBB_SSA;
}

/**********************FUNCTIONS***************************************/
// Subroutine Name: gyroRead
// Read a byte from the gyroscope.
// Inputs: None
// Outputs: Byte read from gyroscope.
// Affected: None
uint8_t gyroRead(uint8_t targetReg){
	uint8_t spiVal = 0x80 | targetReg;
	uint8_t result;
	PORTF_OUTCLR = RBB_SSG;
	spiWrite(spiVal);
	result = spiRead();
	PORTF_OUTSET = RBB_SSG;
	return result;
}

/**********************FUNCTIONS***************************************/
// Subroutine Name: accelWrite
// Write a byte to the gyroscope.
// Inputs: Byte to be written.
// Outputs: None
// Affected: None
void gyroWrite(uint8_t targetReg, uint8_t data){
	uint8_t spiVal = 0x00 | targetReg;
	PORTF_OUTCLR = RBB_SSG;
	spiWrite(spiVal);
	spiWrite(data);
	PORTF_OUTSET = RBB_SSG;
}