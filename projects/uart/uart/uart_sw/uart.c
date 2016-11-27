#include "uart.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <termios.h>

int uart_init(char *fname)
{
	int uart_fd;
	struct termios settings;
	speed_t baud_rate;

	uart_fd = open(fname, O_RDWR | O_NOCTTY | O_NDELAY);

	if (uart_fd < 0) {
		printf("Error opening %s. Error: %s\n", fname, strerror(errno));
		return -1;
	}

	tcgetattr(uart_fd, &settings);

	/*  CONFIGURE THE UART
	 *  The flags (defined in /usr/include/termios.h - see http://pubs.opengroup.org/onlinepubs/007908799/xsh/termios.h.html):
	 *    Baud rate:- B1200, B2400, B4800, B9600, B19200, B38400, B57600, B115200, B230400, B460800, B500000, B576000, B921600, B1000000, B1152000, B1500000, B2000000, B2500000, B3000000, B3500000, B4000000 
	 *    CSIZE:- CS5, CS6, CS7, CS8
	 *	  CLOCAL - Ignore modem status lines
	 *    CREAD - Enable receiver
	 *    IGNPAR = Ignore characters with parity errors
	 *    ICRNL - Map CR to NL on input (Use for ASCII comms where you want to auto correct and of line characters - don't use for binary comms!)
	 *    PARENB - Parity enable
	 *    PARODD - Odd parity (else even) */

	/* Set baud rate - default set to 9600Hz */
	baud_rate = B9600;

	/* Baud rate functions
	 * cfsetospeed - Set output speed
	 * cfsetispeed - Set input speed
	 * cfsetspeed  - Set both output and input speed */

	cfsetspeed(&settings, baud_rate);

	settings.c_cflag &= ~PARENB; /* no parity */
	settings.c_cflag &= ~CSTOPB; /* 1 stop bit */
	settings.c_cflag &= ~CSIZE;
	settings.c_cflag |= CS8 | CLOCAL; /* 8 bits */
	settings.c_lflag = ICANON; /* canonical mode */
	settings.c_oflag &= ~OPOST; /* raw output */

	/* Setting attributes */
	tcflush(uart_fd, TCIFLUSH);
	tcsetattr(uart_fd, TCSANOW, &settings);

	return uart_fd;
}

int uart_release(int uart_fd)
{
	tcflush(uart_fd, TCIFLUSH);
	close(uart_fd);

	return 0;
}

int uart_read(int uart_fd, uint8_t *buffer, int bytes)
{
	int bytes_read;

	/* Don't block serial read */
	fcntl(uart_fd, F_SETFL, FNDELAY);

	while (1) {
		int rx_length = read(uart_fd, buffer, bytes);
		if (rx_length < 0) {
			/* No data yet available, check again */
			if (errno == EAGAIN) {
				fprintf(stderr, "AGAIN!\n");
				continue;
			/* Error differs */
			} else {
				fprintf(stderr, "Error!\n");
				return -1;
			}
		} else if (rx_length == 0) {
			fprintf(stderr, "No data waiting\n");
		/* Print data and exit with while loop */
		} else {
			break;
		}
	}
	
	return bytes_read;
}

int uart_write(int uart_fd, uint8_t *buffer, int bytes)
{
	int bytes_written;

	bytes_written = write(uart_fd, buffer, bytes);
	
	return bytes_written;
}
