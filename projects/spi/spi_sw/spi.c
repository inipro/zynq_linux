#include "spi.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <linux/spi/spidev.h>

int spi_init(char *fname)
{
    /* MODES: mode |= SPI_LOOP;
     *        mode |= SPI_CPHA;
     *        mode |= SPI_CPOL;
     *        mode |= SPI_LSB_FIRST;
     *        mode |= SPI_CS_HIGH;
     *        mode |= SPI_3WIRE;
     *        mode |= SPI_NO_CS;
     *        mode |= SPI_READY;
     * multiple possibilities possible using | */
    int mode = 0;

	int spi_fd;

    /* Opening file stream */
    spi_fd = open(fname, O_RDWR | O_NOCTTY);

    if (spi_fd < 0) {
        printf("Error opening %s. Error: %s\n", fname, strerror(errno));
        return -1;
    }

    /* Setting mode (CPHA, CPOL) */
    if (ioctl(spi_fd, SPI_IOC_WR_MODE, &mode) < 0) {
        printf("Error setting SPI_IOC_WR_MODE. Error: %s\n", strerror(errno));
        return -1;
    }

    /* Setting SPI bus speed */
    int spi_speed = 1000000;

    if (ioctl(spi_fd, SPI_IOC_WR_MAX_SPEED_HZ, &spi_speed) < 0) {
        printf("Error setting SPI_IOC_WR_MAX_SPEED_HZ. Error: %s\n", strerror(errno));
        return -1;
    }

    return spi_fd;
}

int spi_release(int spi_fd)
{
    /* Release the spi resources */
    close(spi_fd);

    return 0;
}

int spi_transfer(int spi_fd, uint8_t *sendBuffer, uint8_t *recvBuffer, int bytes)
{
    struct spi_ioc_transfer xfer;
    memset(&xfer, 0, sizeof(xfer));
    xfer.tx_buf = (uint64_t)sendBuffer;
    xfer.rx_buf = (uint64_t)recvBuffer;
    xfer.len = bytes;

    int res = ioctl(spi_fd, SPI_IOC_MESSAGE(1), &xfer);

    return res;
}

