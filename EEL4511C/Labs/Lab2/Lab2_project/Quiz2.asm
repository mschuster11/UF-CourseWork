; DSP Lab 2 Quiz
; 1. Find the minimum and maximum 32-bit UNSIGNED values in Quiz_Values
; 2. Store the Values in Memory Locations: Min_Value and Max_Value
; 3. If Switch 3 = 0: Display the word "Minimum" to the LCD. Else Display the word "Maximum"
; 4. For the below step, you will display the components of the Minimum value if Switch 3 = 0  and the Maximum value if Switch 3 = 1
; 5. Switch 1:0 = 00: Display bottom 8 bits of Min/Max on the LEDs, 01: Display bits 15:8, 10: Display 23:16, 11: Display bits 31:24

	.def Quiz_Values, Quiz_Values_Length, Min_Value, Max_Value

	.sect "DMARAML7"

Quiz_Values:
	.long 60000
	.long 2857758735
	.long 33
	.long 345
	.long 22222
	.long 1000000000
	.long 2830548975
	.long 2857756741
	.long 22
	.long 1181994
	.long 3692581
	.long 4
	.long 60001
	.long 2857758734
	.long 32
	.long 342
	.long 22221
	.long 1000000001
	.long 2830548974
	.long 2857756740
	.long 223
	.long 1181990
	.long 3692583

Quiz_Values_Length:
	.long (Quiz_Values_Length - Quiz_Values) >> 1

Min_Value: .usect ".ebss", 2
Max_Value: .usect ".ebss", 2
