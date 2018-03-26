// spi.h
// Name:         Mark L. Schuster
// Section #:    1540
// TA Name:      Christopher Crary
// Description:	 Declarations of SPI functions.
#include <avr/io.h>

#ifndef SPI_H_
#define SPI_H_

void spi_init(void);
uint8_t spiWrite(uint8_t data);
uint8_t spiRead(void);


#endif /* SPI_H_ */