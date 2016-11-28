#include "iic.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <linux/i2c-dev.h>

int iic_init(char *fname, uint8_t addr)
{
	int iic_fd;

	iic_fd = open(fname, O_RDWR);

	if (iic_fd < 0) {
		printf("Error opening %s. Error: %s\n", fname, strerror(errno));
		return -1;
	}

	if (ioctl(iic_fd, I2C_SLAVE_FORCE, addr) < 0) {
		printf("Error setting I2C_SLAVE_FORCE. Error: %s\n", strerror(errno));
		return -1;
	}

	return iic_fd;
}

int iic_release(int iic_fd)
{
	close(iic_fd);

	return 0;
}

int iic_read(int iic_fd, uint8_t *buffer, int bytes)
{
	int bytes_read;

	bytes_read = read(iic_fd, buffer, bytes);
	
	return bytes_read;
}

int iic_write(int iic_fd, uint8_t *buffer, int bytes)
{
	int bytes_written;

	bytes_written = write(iic_fd, buffer, bytes);
	
	return bytes_written;
}
