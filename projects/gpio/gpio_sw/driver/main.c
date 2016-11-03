#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include "gpio.h"

#define PS_BTN(i) (956+i)

#define LED(i) (898+i)
#define BTN(i) (902+i)
#define SWS(i) (894+i)

static int loop_exit;

void sig_handler(int signo)
{
	if (signo == SIGINT)
		loop_exit = 1;
}


int main()
{
	if (signal(SIGINT, sig_handler) == SIG_ERR) {
		fprintf(stderr, "can't catch SIGINT\n");
		return 1;
	}
	
	loop_exit = 0;

	/*
	setGpio(PS_BTN(0), "in");
	while (1) {
		int ret = readGpio(PS_BTN(0));
		printf("%d\n", ret);
		sleep(1);
		if (loop_exit == 1) break;

	}
	unsetGpio(PS_BTN(0));
	*/

	/*
	setGpio(LED(0), "out");
	while (1) {
		writeGpio(LED(0), 1);
		sleep(1);
		writeGpio(LED(0), 0);
		sleep(1);
		if (loop_exit == 1) break;
	}
	unsetGpio(LED(0));
	*/

	/*
	setGpio(BTN(0), "in");
	while (1) {
		int ret = readGpio(BTN(0));
		printf("%d\n", ret);
		sleep(1);
		if (loop_exit == 1) break;
	}
	unsetGpio(BTN(0));
	*/

	/*
	setGpio(SWS(0), "in");
	while (1) {
		int ret = readGpio(SWS(0));
		printf("%d\n", ret);
		sleep(1);
		if (loop_exit == 1) break;
	}
	unsetGpio(SWS(0));
	*/

	for(int i=0; i<4; i++) 
		setGpio(LED(i), "out");
	int j=0;
	while (1) {
		writeGpio(LED(j), 1);
		sleep(1);
		writeGpio(LED(j), 0);
		j++;
		if (j==4) j=0;
		if (loop_exit == 1) break;
	}
	for(int i=0; i<4; i++) 
		unsetGpio(LED(i));

	return 0;
}
