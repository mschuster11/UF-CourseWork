/*
 * Hw4.c
 *
 * Created: 10/26/2017 11:23:38 AM
 * Author : Mark
 */ 

#include <avr/io.h>

uint8_t average(uint8_t,uint8_t);

int main(void)
{
    /* Replace with your application code */
	uint8_t num1 = 12;
	uint8_t num2 = 7;
	uint8_t avg = average(num1, num2);
    while (1);

}

uint8_t average(uint8_t a, uint8_t b){
	return (a+b)/2;
}