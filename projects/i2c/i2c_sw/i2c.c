#include "i2c.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <linux/i2c-dev.h>

int i2c_init(char *fname, uint8_t addr)
{
	int i2c_fd;

	i2c_fd = open(fname, O_RDWR);

	if (i2c_fd < 0) {
		printf("Error opening %s. Error: %s\n", fname, strerror(errno));
		return -1;
	}

	if (ioctl(i2c_fd, I2C_SLAVE_FORCE, addr) < 0) {
		printf("Error setting I2C_SLAVE_FORCE. Error: %s\n", strerror(errno));
		return -1;
	}

	return i2c_fd;
}

int i2c_release(int i2c_fd)
{
	close(i2c_fd);

	return 0;
}

int i2c_read(int i2c_fd, uint8_t *buffer, int bytes)
{
	int bytes_read;

	bytes_read = read(i2c_fd, buffer, bytes);
	
	return bytes_read;
}

int i2c_write(int i2c_fd, uint8_t *buffer, int bytes)
{
	int bytes_written;

	bytes_written = write(i2c_fd, buffer, bytes);
	
	return bytes_written;
}
