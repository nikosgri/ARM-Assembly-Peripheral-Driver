
.cpu cortex-m0
.fpu softvfp
.thumb
.section .text
.globl gpio_init
.globl uart_tx_init
.globl uart_transmit_byte
.globl rcc_init
.globl printk

.equ	IOPENR_OFFSET,			0x2C
.equ	RCC_BASE,				0X40021000
.equ	RCC_IOPENR,				(RCC_BASE + IOPENR_OFFSET)

.equ	RCC_CR_OFFSET,			0x00
.equ	RCC_CR,					(RCC_BASE + RCC_CR_OFFSET)

.equ    RCC_CIFR_OFFSET,		0x14
.equ	RCC_CIFR,				(RCC_BASE + RCC_CIFR_OFFSET)

.equ    CFGR_OFFSET,			0x0C
.equ	RCC_CFGR,				(RCC_BASE + CFGR_OFFSET)

.equ	GPIO_MODER_OFFSET,		0x00
.equ 	GPIOx_BASE,				0x50000000
.equ	GPIOA_MODER,			(GPIOx_BASE + GPIO_MODER_OFFSET)

.equ	GPIO_PUPDR_OFFSET,		0x0C
.equ	GPIOA_PUPDR,			(GPIOx_BASE + GPIO_PUPDR_OFFSET)

.equ	AFRL_OFFSET,			0x20
.equ	GPIOA_AFRL,				(GPIOx_BASE + AFRL_OFFSET)

.equ	OSPEEDR_OFFSET,			0x08
.equ	GPIOA_OSPEEDR,			(GPIOx_BASE + OSPEEDR_OFFSET)

.equ	USART_CR1_OFFSET,		0x00
.equ	USART2_BASE,			0x40004400
.equ	USART2_CR1,				(USART2_BASE + USART_CR1_OFFSET)

.equ	CR2_OFFSET,				0x04
.equ	USART2_CR2,				(USART2_BASE + CR2_OFFSET)

.equ	APB1_OFFSET,			0x38
.equ	RCC_APB1ENR,			(RCC_BASE + APB1_OFFSET)

.equ	BRR_OFFSET,				0x0C
.equ	USART2_BRR,				(USART2_BASE + BRR_OFFSET)

.equ	ISR_OFFSET,				0x1C
.equ	USART2_ISR,				(USART2_BASE + ISR_OFFSET)

.equ	TDR_OFFSET,				0x28
.equ	USART2_TDR,				(USART2_BASE + TDR_OFFSET)



rcc_init:
				/* Set HSI16 clock on*/
				ldr r0,=RCC_CR
				ldr r1,[r0]
				mov r2,#0x01
				orr r1,r1,r2
				str r1,[r0]
				/* Wait for HSI16 to be ready*/
				ldr r0,=RCC_CR
loop2:			ldr r1,[r0]
				mov r2,#1
				lsl r2,r2,#2
				and r1,r1,r2
				cmp r1,#0
				beq loop2
				/* Set HSI16 as system clock source*/
				ldr r0,=RCC_CFGR
				ldr r1,[r0]
				mov r2,#0x01
				orr r1,r1,r2
				mov r3,#0x02
				bic r1,r1,r3
				str r1,[r0]
				bx  lr
gpio_init:
				/* Enable clock access to port A*/
				ldr	r0,=RCC_IOPENR
				ldr r1,[r0]
				mov r2,#0x1
				orr r1,r1,r2
				str r1,[r0]
				/* Set pin 2 as alternate function mode*/
				ldr r0,=GPIOA_MODER
				ldr r1,[r0]
				mov r2,#1
				lsl r2,r2,#5
				orr r1,r1,r2
				mov r3,#0x10
				bic r1,r1,r3
				str r1,[r0]
				/* Set type as output push pull*/
				//Reset value of register does the job by default
				/* Set high speen to TX pin PA2*/
				ldr r0,=GPIOA_OSPEEDR
				ldr r1,[r0]
				mov r2,#1
				lsl r2,r2,#5
				orr r1,r1,r2
				mov r3,#1
				lsl r3,r3,#4
				mvn r3,r3
				and r1,r1,r3
				str r1,[r0]
				/* No push-pull, no pull-up*/
				ldr r0,=GPIOA_PUPDR
				ldr r1,=0x00
				str r1,[r0]
				/* Set pin 2 of port A, as alternate function 4 (AF4)*/
				ldr r0,=GPIOA_AFRL
				ldr r1,[r0]
				mov r2,#1
				lsl r2,r2,#10
				orr r1,r1,r2
				mov r3,#1
				lsl r3,r3,#11
				mvn r3,r3
				and r1,r1,r3
				mov r4,#1
				lsl r4,r4,#9
				mvn r4,r4
				and r1,r1,r4
				mov r5,#1
				lsl r5,r5,#8
				mvn r5,r5
				and r1,r1,r5
				str r1,[r0]
				/* Set pin 3 as alternate function mode*/
				ldr r0,=GPIOA_MODER
				ldr r1,[r0]
				mov r2,#1
				lsl r2,r2,#7
				orr r1,r1,r2
				mov r3,#1
				lsl r3,r3,#6
				mvn r3,r3
				and r1,r1,r3
				str r1,[r0]
				/* Set high speen to RX pin PA3*/
				ldr r0,=GPIOA_OSPEEDR
				ldr r1,[r0]
				mov r2,#1
				lsl r2,r2,#7
				orr r1,r1,r2
				mov r3,#1
				lsl r3,r3,#6
				mvn r3,r3
				and r1,r1,r3
				str r1,[r0]
				/* Set pin 3 of port A, as alternate function 4 (AF4)*/
				ldr r0,=GPIOA_AFRL
				ldr r1,[r0]
				mov r2,#1
				lsl r2,r2,#14
				orr r1,r1,r2
				mov r3,#1
				lsl r3,r3,#15
				mvn r3,r3
				and r1,r1,r3
				mov r4,#1
				lsl r4,r4,#13
				mvn r4,r4
				and r1,r1,r4
				mov r5,#1
				lsl r5,r5,#12
				mvn r5,r5
				and r1,r1,r5
				str r1,[r0]
				bx  lr

uart_tx_init:
				/* Enable clock access to USART2*/
				ldr r0,=RCC_APB1ENR
				ldr r1,[r0]
				mov r2,#1
				lsl r2,r2,#17
				orr r1,r1,r2
				str r1,[r0]
				/* Disable USART2*/
				ldr r0,=USART2_CR1
				ldr r1,[r0]
				mov r2,#0x01
				mvn r2,r2
				and r1,r1,r2
				str r1,[r0]
				/* Set two stop bits*/
				ldr r0,=USART2_CR2
				ldr r1,[r0]
				mov r2,#1
				lsl r2,r2,#13
				orr r1,r1,r2
				mov r3,#1
				lsl r3,r3,#12
				mvn r3,r3
				and r1,r1,r3
				str r1,[r0]
				/* Set the baudrate equal to 115200*/
				ldr r0,=USART2_BRR
				mov r1,#138	// OVER16, 16MHz / 115200 = 138.32...
				str r1,[r0]
				/* Set TE bit, to enable transmitter*/
				ldr r0,=USART2_CR1
				mov r1,#0x08
				str r1,[r0]
				/* Enable USART2*/
				ldr r0,=USART2_CR1
				ldr r1,[r0]
				mov r2,#0x01
				orr r1,r1,r2
				str r1,[r0]
				bx  lr

uart_transmit_byte:

				/* Check if TX fifo is ready to store data, before storing them to TDR register*/
				ldr r1,=USART2_ISR
loop:			ldr r2,[r1]
				mov r3,#1
				lsl r3,r3,#7
				and r2,r2,r3
				cmp r2,#0
				beq loop
				/* Send data to TDR register*/
				mov r1,r0
				ldr r2,=USART2_TDR
				str r1,[r2]
				/* Wait TC bit after a write in TDR register*/
				ldr r1,=USART2_ISR
loop1:			ldr r2,[r1]
				mov r3,#1
				lsl r3,r3,#6
				and r2,r2,r3
				cmp r2,#0
				beq loop1
				bx  lr
