#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include "i2c.h"

#define TMP3_ADDR			0x48
#define TMP3_REG_TEMP		0x0	

static int loop_exit;

void sig_handler(int signo)
{
	if (signo == SIGINT)
		loop_exit = 1;
}

int main()
{
	int i2c_fd;
	uint8_t cmd;
	uint8_t dat[30];
	uint16_t _temp;
	double temp;

	if (signal(SIGINT, sig_handler) == SIG_ERR) {
		fprintf(stderr, "can't catch SIGINT\n");
		return 1;
	}

	loop_exit = 0;

	//i2c_fd = i2c_init("/dev/i2c-1", TMP3_ADDR);
	i2c_fd = i2c_init("/dev/i2c-2", TMP3_ADDR);

	cmd = TMP3_REG_TEMP;

	while (1) {
		i2c_write(i2c_fd, &cmd, 1);
		i2c_read(i2c_fd, dat, 2);

		_temp = dat[1] | (dat[0] << 8);
		if (dat[0] & 0x80 == 0)
			temp = (int)_temp / 256.0;
		else
			temp = -1 * (int)(~_temp + 1) / 256.0;

		printf("temp = %g\n", temp);
		sleep(1);

		if (loop_exit == 1) break;
	}

	i2c_release(i2c_fd);

}
