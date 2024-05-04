#include <string.h>	//Because I use strlen function


extern void rcc_init(void);
extern void gpio_init(void);
extern void uart_tx_init(void);
extern void uart_transmit_byte(char byte);

void printk(char *string, int len);


int main(void)
{

	char *buffer;
	int len;

	/* Initialize clock to our system*/
	rcc_init();
	/* Initialize GPIO's*/
	gpio_init();
	/* Initialize transmitter*/
	uart_tx_init();
	/* Declare parameters*/
	buffer = "Hello World\n\r";
	len = strlen(buffer);
	/* Transmit to terminal*/
	printk(buffer, len);

	return 0;
}

void printk(char *string, int len){

	for (int i=0;i<len;i++){
		uart_transmit_byte(string[i]);
	}

}
