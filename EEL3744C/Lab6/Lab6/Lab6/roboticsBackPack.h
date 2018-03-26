// roboticsBackpack.h
// Name:         Mark L. Schuster
// Section #:    1540
// TA Name:      Christopher Crary
// Description:	 Declarations of robotics backpack functions.
#include <avr/io.h>

#ifndef ROBOTICSBACKPACK_H_
#define ROBOTICSBACKPACK_H_

//	PORTF CONTROL SIGNALS
#define RBB_SDA								(0x01<<0)
#define RBB_SCL								(0x01<<1)
#define RBB_SENSOR_SEL						(0x01<<2)
#define RBB_SSA								(0x01<<3)
#define RBB_SSG								(0x01<<4)
#define RBB_MOSI							(0x01<<5)
#define RBB_MISO							(0x01<<6)
#define RBB_SCK								(0x01<<7)

//	PORTC CONTROL SIGNALS
#define RBB_PWMA							(0x01<<0)
#define RBB_PWMB							(0x01<<1)
#define RBB_AIN2							(0x01<<2)
#define RBB_AIN1							(0x01<<3)
#define RBB_BIN2							(0x01<<4)
#define RBB_BIN1							(0x01<<5)
#define RBB_INT2A							(0x01<<6)
#define RBB_INT1A							(0x01<<7)

//	PORTA CONTROL SIGNALS
#define RBB_STBY							(0x01<<0)
#define RBB_INT2G							(0x01<<1)
#define RBB_INT1G							(0x01<<2)
#define RBB_GYRO_ENABLE						(0x01<<3)
#define RBB_PROTOCOL_SEL					(0x01<<4)
#define RBB_PA5								(0x01<<5)
#define RBB_PA6								(0x01<<6)
#define RBB_PA7								(0x01<<7)



#define RBB_SENSOR_SEL_GYRO_bm				0
#define RBB_SENSOR_SEL_GYRO_bp				(0x01<<2)
#define RBB_SENSOR_SEL_ACCEl_bm				1
#define RBB_SENSOR_SEL_ACCEl_bp				(0x01<<2)

#define RBB_PROTOCOL_SEL_SPI_bm				0
#define RBB_PROTOCOL_SEL_SPI_bp				(0x01<<4)
#define RBB_PROTOCOL_SEL_I2C_bm				1
#define RBB_PROTOCOL_SEL_I2C_bp				(0x01<<4)


// FUNCTIONS
void accel_init(void);
uint8_t accelRead(uint8_t);
void accelWrite(uint8_t, uint8_t);
uint8_t gyroRead(uint8_t);
void gyroWrite(uint8_t, uint8_t);



#endif /* ROBOTICSBACKPACK_H_ */