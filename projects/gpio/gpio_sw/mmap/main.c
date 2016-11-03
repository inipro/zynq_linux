/*
xgpio_g.c

XGpio_Config XGpio_ConfigTable[] =
{
    {
        XPAR_BTNS_4BITS_DEVICE_ID, // 0 
        XPAR_BTNS_4BITS_BASEADDR,  // 0x40001000 
        XPAR_BTNS_4BITS_INTERRUPT_PRESENT, // 1 
        XPAR_BTNS_4BITS_IS_DUAL // 0 
    },
    {
        XPAR_LEDS_4BITS_DEVICE_ID, // 1 
        XPAR_LEDS_4BITS_BASEADDR,  // 0x40000000 
        XPAR_LEDS_4BITS_INTERRUPT_PRESENT, // 1
        XPAR_LEDS_4BITS_IS_DUAL // 0
    },
    {
        XPAR_SWS_4BITS_DEVICE_ID, // 2
        XPAR_SWS_4BITS_BASEADDR, // 0x40002000
        XPAR_SWS_4BITS_INTERRUPT_PRESENT, // 1
        XPAR_SWS_4BITS_IS_DUAL // 0
    }
};
*/

#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <signal.h>
#include "xgpio.h"

XGpio_Config XGpio_ConfigTable[3] = {
	{ 0, 0, 1, 0 },
	{ 1, 0, 1, 0 },
	{ 2, 0, 1, 0 }
};

static int loop_exit;

void sig_handler(int signo)
{
	if (signo == SIGINT)
		loop_exit = 1;
}

int main()
{
	int fd;
	uint32_t btns, leds, sws;

	if ((fd = open("/dev/mem", O_RDWR)) < 0) {
		perror("open");
		return 1;
	}

	btns =  (uint32_t)mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40001000);
	leds =  (uint32_t)mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40000000);
	sws =  (uint32_t)mmap(NULL, sysconf(_SC_PAGESIZE), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x40002000);

	XGpio_ConfigTable[0].BaseAddress = btns;
	XGpio_ConfigTable[1].BaseAddress = leds;
	XGpio_ConfigTable[2].BaseAddress = sws;

	if (signal(SIGINT, sig_handler) == SIG_ERR) {
		fprintf(stderr, "can't catch SIGINT\n");
		return 1;
	}

	XGpio Gpio;
	int Status;
	Status = XGpio_Initialize(&Gpio, 1);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	loop_exit = 0;
	while (1) {
		XGpio_DiscreteWrite(&Gpio, 1, 0xF);
		sleep(1);
		XGpio_DiscreteWrite(&Gpio, 1, 0x0);
		sleep(1);
		if (loop_exit == 1) break;
	}

	return 0;
}
