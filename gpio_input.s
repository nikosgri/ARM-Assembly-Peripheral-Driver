.globl main
.cpu cortex-m0
.thumb
.section .text

/* 		Press the input button of the board and open the green LED.

Actions:
			1) The green LED is connected to PA5
				1.1) Configure this pin as output
			2) The push button is connected to PC13
				2.1) Configure this pin as input
*/

.equ	RCC_BASE,		0x40021000
.equ	IOPENR_OFFSET,	0x2C
.equ	RCC_IOPENR,		(RCC_BASE + IOPENR_OFFSET)

.equ	GPIOA_BASE,		0x50000000
.equ	MODER_OFFSET,	0x00
.equ	GPIOA_MODER,	(GPIOA_BASE + MODER_OFFSET)

.equ	BSRR_OFFSET,	0x18
.equ	GPIOA_BSRR,		(GPIOA_BASE + BSRR_OFFSET)

.equ	GPIOC_BASE,		0X50000800
.equ	GPIOC_MODER,	(GPIOC_BASE + MODER_OFFSET)

.equ	IDR_OFFSET,		0x10
.equ	GPIOC_IDR,		(GPIOC_BASE + IDR_OFFSET)


.equ	IOPAEN,			(1U<<0)	 // Bit zero of RCC_IOPENR, is responsible for giving clock access to port A.
.equ	IOPCEN,			(1U<<2)  // Bit two of RCC_IOPENR, is responsible for giving clock access to port C.

/* Moder register needs 1 to bit 10 and 0 to bit 11, to set pin 5 as output*/
.equ	MODE5_0,		(1U<<10) // Bit 10
.equ	MODE5_1,		(1U<<11) // Bit 11
/* Moder register needs 0 to bit 26 and 0 to bit 27, to set pin 13 as input.
	(As its reset value is 0x00, we could avoid this step, because it is already as input mode)
*/
.equ	MODE13_0,		(1U<<26) // Bit 26
.equ	MODE13_1,		(1U<<27) // Bit 27

.equ	PIN_13,			0x2000	// Bit 13n
.equ	PIN_ON,			0x0000
.equ	PIN_OFF,		0x2000

.equ	BS5,			(1U<<5)  // Bit 5 of BSSR register, is responsible for setting the pin high
.equ	BR5,			(1U<<21) // Bit 21 of BSSR register, is responsible for setting the pin low


main:
			bl	gpio_init	//Initialize GPIO pins


loop:
			/* Read input pin 13 on port C, and every time is pressed enable the led */
			bl	get_input
			cmp r1,#PIN_ON
			beq	button_pressed
			bl  button_released
			b	loop

get_input:
			/* Read the input pin 13*/
			ldr r0,=GPIOC_IDR
			ldr r1,[r0]
			ldr r2, =PIN_13
			and r1,r1,r2
			bx	lr

gpio_init:
			/* Initialize GPIO pins */

			/* Enable clock access to GPIOA */
			ldr	r0,=RCC_IOPENR
			ldr	r1,[r0]
			ldr	r2,=IOPAEN
			orr	r1,r1,r2
			str r1,[r0]
			/* Configure pin 5 as GPIO output mode*/
			ldr r0,=GPIOA_MODER
			ldr r1,[r0]
			ldr r2,=MODE5_0
			orr	r1,r1,r2
			str r1,[r0]
			ldr r2,=MODE5_1
			mvn r2,r2
			and r1,r1,r2
			str r1,[r0]
			/* Enable clock access to GPIOC*/
			ldr	r0,=RCC_IOPENR
			ldr	r1,[r0]
			ldr r2,=IOPCEN
			orr r1,r1,r2
			str r1,[r0]
			/* Configure pin 13 as GPIO input*/
			ldr r0,=GPIOC_MODER
			ldr r1,[r0]
			ldr r2,=MODE13_0
			mvn r2,r2
			and r1,r1,r2
			str r1,[r0]
			ldr r2,=MODE13_1
			mvn r2,r2
			and r1,r1,r2
			str r1,[r0]
			bx 	lr

button_pressed:
			/* Turn on the LED */
			ldr r0,=GPIOA_BSRR
			ldr r1,[r0]
			ldr r2,=BS5
			orr r1,r1,r2
			str r1,[r0]
			b	loop
button_released:
			/* Turn off the LED */
			ldr r0,=GPIOA_BSRR
			ldr r1,[r0]
			ldr r2,=BR5
			orr r1,r1,r2
			str r1,[r0]
			b	loop
exit:
			b exit
			.align
