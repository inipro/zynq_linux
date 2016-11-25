#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include "PmodCLS.h"

static int loop_exit;

void sig_handler(int signo)
{
	if (signo == SIGINT)
		loop_exit = 1;
}

char szInfo1[0x20];
char szInfo2[0x20];

int main()
{
	if (signal(SIGINT, sig_handler) == SIG_ERR) {
		fprintf(stderr, "can't catch SIGINT\n");
		return 1;
	}

	loop_exit = 0;

	//CLS_begin("/dev/spidev0.0");
	CLS_begin("/dev/spidev1.0");

	CLS_DisplayClear();

	strcpy(szInfo1, "  PmodCLS Demo");
	strcpy(szInfo2, "  Hello World!");

	CLS_WriteStringAtPos(0, 0, szInfo1);
	CLS_WriteStringAtPos(1, 0, szInfo2);

	usleep(500000);

	while (1) {
		CLS_DisplayClear();

		strcpy(szInfo1, "->PmodCLS Demo<- ");

		CLS_WriteStringAtPos(0, 0, szInfo1);
		CLS_WriteStringAtPos(1, 0, szInfo2);

		usleep(500000);

		CLS_DisplayClear();

		strcpy(szInfo1, "  PmodCLS Demo   ");

		CLS_WriteStringAtPos(0, 0, szInfo1);
		CLS_WriteStringAtPos(1, 0, szInfo2);

		usleep(500000);

		if (loop_exit == 1) break;

	}

	CLS_end();

	return 0;
}
