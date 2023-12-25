# ARM_Assembly_GPIO_Input
A simple program, that demonstrates how to open an LED with the press of a button
## STM32L053R8, exloring memory map
As you can see in the figure 1, we have the memory map of the microcontroller. Peripherals starts from address 0x40000000 all the way up to 0x50001FFF.
In this specific range of memory, are stored buses like AHB, gpios and etc. 

![Memory Map](https://github.com/nikosgri/ARM_Assembly_GPIO_Input/blob/master/img/Screenshot%202023-12-25%20at%204.06.16%20PM.png)

### Locating registers
First and foremost, we have to follow some simple steps, that will define to us what register we will need. Those steps are:
1) Enable clock access for port A.   (**RCC_IOPENR, register**)
2) Define pin 5 as output pin. User led, is connected to PA5. (**MODER, register**)
3) No need to configure output push-pull, because reset values does the job by default.
4) Enable clock access to port C.   (**RCC_IOPENR, register**)
5) Define pin 13 as input pin. User push-button is connected to PC13. We could have avoid this step because once more, the reset value of the register does the job, by default. (**MODER, register**)
6) Setting and resseting the pin 13 of port C, in order to open and close LED. (**BSRR, register**)
   
![Alt text](image link)

Elaborating more to that topic, if we give a closer look to the register map, we can find that the RCC peripheral can be accessed thoughout the AHB bus. Thus, we defing the base address of RCC  like RCC_BASE 0X4002 1000, as figure two illustrates and after that we can access any register of RCC, by adding the offset value of it, into the RCC_BASE. For instance, the reset value of IOPENR register is IOPENE_OFFSET = 0x2C, hence we can access that register by doing a simple step like: RCC_IOPENR (RCC_BASE + IOPENR_OFFSET). With that way, we are able to manipulate its bits and enable clock access to every port we want. Similar steps are followed to other resisters. Keep in my mind that the offset values are the same for each peripheral, although the peripherls has different base addresses. 

## Branch instructions
1) bl  Branch to label
2) bx  lr return from a label(function). BX stands for  branch and exchange instruction set.

## STM32L053R8 block diagram
![Alt text](image link)
