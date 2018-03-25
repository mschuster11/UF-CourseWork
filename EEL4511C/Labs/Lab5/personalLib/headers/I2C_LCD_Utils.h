//  File:   I2C_LCD_Utils.h
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#ifndef I2CLCDUTILS_H_
#define I2CLCDUTILS_H_


// Initializes the LCD and clears the display.
void initLCD(void);

// Sends a command to the LCD over I2C.
void sendCmdListLCD(Uint16 *, Uint16);

// Writes a character to the LCD after it has been
// initialized with "initLCD".
void sendCharLCD(char);

// Writes a string to the LCD using "sendCharLCD".
void sendStringLCD(char*);

// Send the clear screen to the LCD,
// wiping the display.
void clearLCD(void);

// Set the LCD's cursor the first
// position in the top right corner.
void cursorHomeLCD(void);

#endif
