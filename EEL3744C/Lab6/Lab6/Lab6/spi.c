// spi.c
// Name:         Mark L. Schuster
// Section #:    1540
// TA Name:      Christopher Crary
// Description:	 Definitions of SPI functions.


 #include "spi.h"

 /**********************FUNCTIONS***************************************/
 // Subroutine Name: spi_init
 // Configure the SPI peripheral
 // Inputs: None
 // Outputs: None
 // Affected: None
 void spi_init(void){

	 PORTF_DIRSET = 0b10111100;
	 PORTF_DIRCLR = 0b01000011;
	 // Master, MSB DORD, LE:RS, TE:FS, SYS_CLK/4 = 8MHz
	 SPIF_CTRL = SPI_ENABLE_bm | SPI_MASTER_bm | SPI_MODE_0_gc | SPI_PRESCALER_DIV4_gc;

	 return;
 }

 /**********************FUNCTIONS***************************************/
 // Subroutine Name: spiWrite
 // Write a byte of data using SPI
 // Inputs: data - data to be sent
 // Outputs: None
 // Affected: None
 uint8_t spiWrite(uint8_t data){
	 SPIF_DATA = data;
	 while(!(SPIF_STATUS & SPI_IF_bm));
	 return SPIF_DATA;
 }

 /**********************FUNCTIONS***************************************/
 // Subroutine Name: spiRead
 // Reads the return value of spiWrite.
 // Inputs: None
 // Outputs: Return value of spiWrite.
 // Affected: None
 uint8_t spiRead(void){
	 return  spiWrite(0xFF);
 }