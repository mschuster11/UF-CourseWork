// Lab 5 part G
// Name:         Mark L. Schuster
// Section #:    1540
// TA Name:      Christopher Crary
// Description:  Play a waveform out of the speaker.

#include <avr/io.h>
#include <avr/interrupt.h>
//#include "ebi_driver.h"

#define CS0_Start 0x8000
#define CS0_End 0xFFFF
typedef uint8_t bool; enum{
	FALSE=0,
	TRUE
	};

#define CLK_PRESCALER	CLK_PSADIV_1_gc

void INIT_CLK(void);
void INIT_INTS(void);
void INIT_EBI(void);
void INIT_ADC(void);
void INIT_DAC(void);
void INIT_USART(void);
char IN_CHAR(void);
void OUT_CHAR(char);
void OUT_STRING(char*);
void OUT_STRINGLN(char*);
void OUT_STRINGPG(char*);
void DELAY(void);
void RECORD(void);
void PLAY_NORMAL(void);
void PLAY_SLOW(void);
void PLAY_FAST(void);

static volatile bool record = FALSE;
static volatile bool playNormal = TRUE;
static volatile bool playFast = FALSE;
static volatile bool playSlow = FALSE;
static volatile bool play = TRUE;
static volatile uint8_t *EBIptr = CS0_Start; 
static volatile char choice = 'Q';


int main(void)
{
	// Init CLK, pin dir, and ADC.
	INIT_CLK();
	INIT_USART();
	INIT_INTS();
	INIT_EBI();
	INIT_ADC();

	DELAY();
	
	
	// Set the direction of the DAC output.
	PORTA_DIRCLR = 0xE0;
	PORTA_DIRSET = 0x0C;
	PORTC_DIRSET = 0x81;
	PORTC_OUTSET = 0x80;

	// Init the DAC.
	INIT_DAC();


	OUT_STRINGLN("P - Play Audio");
	OUT_STRINGLN("R - Record Audio");
	OUT_STRINGLN("S - Slow Down Audio");
	OUT_STRINGLN("F - Speed Up Audio");
	OUT_STRINGLN("Q - Stop Audio");
	OUT_STRINGLN("N - Normalize Audio");

	while (1)
	{
		while(choice == 0x00);
		switch(choice){
			case 'P':
			case 'p':
			
				TCC0_PER = 90;
				play = TRUE;
				break;
			case 'R':
			case 'r':
				//OUT_CHAR(choice);
				if(!record){
					record = TRUE;
					EBIptr = CS0_Start; 
				}
				break;
			case 'S':
			case 's':
				TCC0_PER = 180;
				playFast = FALSE;
				playNormal = FALSE;
				playSlow = TRUE;
				break;
			case 'F':
			case 'f':
				TCC0_PER = 45;
				playSlow = FALSE;
				playNormal = FALSE;
				playFast = TRUE;
				break;
			case 'Q':
			case 'q':
				//OUT_CHAR(choice);
				play = FALSE;
				break;
			case 'N':
			case 'n':
				TCC0_PER = 90;
				playFast = FALSE;
				playSlow = FALSE;
				playNormal = TRUE;
				break;
		}
		choice = 0x00;
	}
	
	

}

ISR(USARTD0_RXC_vect){
	choice = USARTD0_DATA;
	//USARTD0_STATUS = 0x80;
	return;
}
ISR(USARTD0_TXC_vect){
	//USARTD0_STATUS = 0x40;
	return;
}

ISR(USARTD0_DRE_vect){
	//USARTD0_STATUS = 0x20;
	return;
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
// Subroutine Name: INIT_INTS
// Init interrupts.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_INTS(void){
	// Set the PMIC to enable low level interrupts.
	PMIC_CTRL |= PMIC_LOLVLEN_bm;
	PMIC_CTRL |= PMIC_MEDLVLEN_bm;
	// Set the interrupt enable bit.
	CPU_SREG |= 0x80;
}


/**********************FUNCTIONS***************************************/
// Subroutine Name: INIT_USART
// Init the USART regs.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_USART(void){
	// Set the direction of the Tx & Rx pins.
	PORTD_DIRSET = USART_TXEN_bm;
	PORTD_DIRCLR = USART_RXEN_bm;
	
	// Set the baud rate.
	USARTD0_BAUDCTRLA = 1;
	USARTD0_BAUDCTRLB = 0;
	
	// Set the data size and the mode.
	USARTD0_CTRLC = USART_CHSIZE_8BIT_gc;
	USARTD0_CTRLA = 0b00100101;
	USARTD0_CTRLB = 0b00011000;
	
}

void INIT_EBI()
{
	PORTH_DIR = 0x37;       // Enable RE, WE, CS0, CS1, ALE1
	PORTH_OUT = 0x33;
	PORTK_DIR = 0xFF;       // Enable Address 7:0 (outputs)
	// Do not need to set PortJ to outputs
	
	EBI.CTRL = EBI_SRMODE_ALE1_gc | EBI_IFMODE_3PORT_gc;            // ALE1 multiplexing, 3 port configuration

	EBI.CS0.BASEADDRH = (uint8_t) (CS0_Start>>16) & 0xFF;
	EBI.CS0.BASEADDRL = (uint8_t) (CS0_Start>>8) & 0xFF;            // Set CS0 range to 0x008000 - 0x00FFFF
	EBI.CS0.CTRLA = EBI_CS_MODE_SRAM_gc | EBI_CS_ASPACE_32KB_gc;	    // SRAM mode, 32k address space
}




//*********************FUNCTIONS**************************************
// Subroutine Name: INIT_ADC
// Init the ADCA.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_ADC(void){
	// Set the ADC's reference to AREFB.
	ADCA_REFCTRL = ADC_REFSEL_AREFB_gc;

	// Set the res to 8-bits and signed mode.
	ADCA_CTRLB = ADC_RESOLUTION_12BIT_gc | ADC_CONMODE_bm | ADC_FREERUN_bm;

	// Set the prescaler to div 512.
	//ADCA_PRESCALER = ADC_PRESCALER_DIV512_gc;
	ADCA_PRESCALER = ADC_PRESCALER_DIV16_gc;

	// Set the input pins to be 1 and 6.
	ADCA_CH0_MUXCTRL = ADC_CH_MUXPOS_PIN4_gc | ADC_CH_MUXNEG_PIN5_gc;

	// Set the mode to differential voltage with a gain of 1.
	ADCA_CH0_CTRL = ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;
	
	ADCA_CH0_INTCTRL = ADC_CH_INTLVL_LO_gc;
	
	// Enable the ADC.
	ADCA_CTRLA = 0x05;

}

/**********************FUNCTIONS***************************************/
// Subroutine Name: INIT_DAC
// Init the DAC.
// Inputs: None
// Outputs: None
// Affected: None
void INIT_DAC(void){
	// Set the direction of the DAC output.
	PORTA_DIRSET = 0x08;
	
	// Set to single channel mode.
	DACA.CTRLB = DAC_CHSEL1_bm;
	
	// Set PortB as the external reference.
	DACA.CTRLC = 0b00011000;
	
	// Set the persistent data for 0.7V out.
	DACA.CH0DATA= 0x0000;
	
	// Enable channel 0 and the DAC.
	DACA.CTRLA = (DAC_CH1EN_bm | DAC_ENABLE_bm);

	
}


/**********************FUNCTIONS***************************************/
// Subroutine Name: DELAY
// Used to created a delay.
// Inputs: None
// Outputs: None
// Affected: None
void DELAY(void){
	
	//Set the period.
	//TCC0_PER = 125;
	//TCC0_PER = 80;
	TCC0_PER = 90;
	
	// Enable the interrupt and then the timer.
	TCC0_INTCTRLA = TC_OVFINTLVL_LO_gc;
	TCC0_CTRLA = TC_CLKSEL_DIV8_gc;
	//TCC0_CTRLA = TC_CLKSEL_DIV256_gc;
}


/**********************FUNCTIONS***************************************/
// Subroutine Name: OUT_CHAR
// Send a char over USART.
// Inputs: char c = input char
// Outputs: None
// Affected: None
void OUT_CHAR(char c){
	// Wait for the data buffer to be ready for
	// input, load the character, finally wait until 
	// transmission is complete.
	while(!(USARTD0_STATUS & USART_DREIF_bm));
	USARTD0_DATA = c;
	while(!(USARTD0_STATUS & USART_TXCIF_bm));
	USARTD0_STATUS = 0x40;
	return;
}

/**********************FUNCTIONS***************************************/
// Subroutine Name: OUT_STRING
// Send a string over USART.
// Inputs: char* s = input string
// Outputs: None
// Affected: None
void OUT_STRING(char* s){
	// Wait for the data buffer to be ready for
	// input, load the character, finally wait until 
	// transmission is complete. Loop until the
	// NULL terminator is reached.
	for(uint8_t i=0; s[i]!='\0'; i++){
		while(!(USARTD0_STATUS & USART_DREIF_bm));
		USARTD0_DATA = s[i];
		while(!(USARTD0_STATUS & USART_TXCIF_bm));
		USARTD0_STATUS = 0x40;
	}
	
	return;
}


/**********************FUNCTIONS***************************************/
// Subroutine Name: OUT_STRINGLN
// Send a string over USART with a new line.
// Inputs: char* s = input string
// Outputs: None
// Affected: None
void OUT_STRINGLN(char* s){
	// Print the string, then set a new line.
	OUT_STRING(s);
	OUT_CHAR('\r');
	OUT_CHAR('\n');
	
	return;
}

/**********************FUNCTIONS***************************************/
// Subroutine Name: OUT_STRINGPG
// Send a string over USART with a new page.
// Inputs: char* s = input string
// Outputs: None
// Affected: None
void OUT_STRINGPG(char* s){
	// Move to a new page, then print the string.
	OUT_CHAR('\f');
	OUT_STRING(s);
	
	return;
}






/*********************INTERUPT****************************************/
//Sets up an interrupt to be triggered by the completion of channel 0
//of ADCA.
//Inputs: None
//Outputs: None
//Affected: None

ISR(ADCA_CH0_vect)
{
	ADCA_CH0_CTRL |=  0x80;
	return;
}



ISR(TCC0_OVF_vect)
{	
	if(record){
		PORTC_OUTTGL = 1;
		double resDec = (1.0/820.0)*(ADCA_CH0RES)*(0xFFF/2.5);
		if(resDec > 0xFFF)
			resDec = 0;
		*EBIptr++ = resDec;
		if((EBIptr == CS0_End) || EBIptr < CS0_Start){
			EBIptr = CS0_Start;
			record = FALSE;
			}
	}else if(play){
		if(playNormal){
			PORTC_OUTTGL = 1;
			DACA.CH1DATA = *EBIptr++;
			if((EBIptr == CS0_End) || EBIptr < CS0_Start)
				EBIptr = CS0_Start;
		}else if(playSlow){
				PORTC_OUTTGL = 1;
				DACA.CH1DATA = *EBIptr++;
				if((EBIptr == CS0_End) || EBIptr < CS0_Start)
					EBIptr = CS0_Start;
		}else if(playFast){
			PORTC_OUTTGL = 1;
			DACA.CH1DATA = *EBIptr++;
			if((EBIptr == CS0_End) || EBIptr < CS0_Start)
				EBIptr = CS0_Start;
		}
		
	}
	return;
}

