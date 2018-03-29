//  File:   I2C_LCD_Utils.c
//  Date:   02/24/2018
//  Name:   Mark Schuster
//  Class:  EEE4511C (DSP)

#include "msLib.h"


// Initializes the LCD and clears the display.
void initLCD(void)
{
    Uint16 LCDCommandList[] = {0x33,0x32,0x28,0x0F,0x01};
    I2C_O2O_Master_Init(0x3F, 150, 400);
    sendCmdListLCD(LCDCommandList, sizeof(LCDCommandList)/sizeof(Uint16));
    cursorHomeLCD();

    return;
}


// Sends a command to the LCD over I2C.
void sendCmdListLCD(Uint16 *cmdList, Uint16 cmdListLen)
{
    for(Uint16 itter=0; itter<cmdListLen; itter++)
    {
        Uint16 upperNibble, lowerNibble;
        lowerNibble = ((cmdList[itter] & 0x000F) << 4) | 0x8;
        upperNibble = (cmdList[itter] & 0x00F0) | 0x8;
        Uint16 nibbleEnableCmds[] = { (upperNibble | 0x4), upperNibble,
                                      (lowerNibble | 0x4), lowerNibble};
        I2C_O2O_SendBytes(nibbleEnableCmds, sizeof(nibbleEnableCmds)/sizeof(Uint16));
    }
    DELAY_US(1000);

    return;
}


// Writes a character to the LCD after it has been
// initialized with "initLCD".
void sendCharLCD(char c){


    Uint16 upperNibble, lowerNibble;
    lowerNibble = (((Uint16)c & 0x000F) << 4) | 0x9;
    upperNibble = ((Uint16)c & 0x00F0) | 0x9;
    Uint16 nibbleEnableCmds[] = { (upperNibble | 0x4), upperNibble,
                                  (lowerNibble | 0x4), lowerNibble};
    I2C_O2O_SendBytes(nibbleEnableCmds, sizeof(nibbleEnableCmds)/sizeof(Uint16));

    return;
}


// Writes a string to the LCD using "sendCharLCD".
void sendStringLCD(char* str){
    for(Uint16 itter=0; str[itter]!='\0'; itter++)
        sendCharLCD(str[itter]);

    return;
}


// Send the clear screen to the LCD,
// wiping the display.
void clearLCD(void)
{
    Uint16 clearVal[] = {0x01};
    sendCmdListLCD(clearVal, sizeof(clearVal)/sizeof(Uint16));

    return;
}


// Set the LCD's cursor the first
// position in the top right corner.
void cursorHomeLCD(void){
    Uint16 homeVal[] = {0x02};
    sendCmdListLCD(homeVal, sizeof(homeVal)/sizeof(Uint16));

    return;
}
