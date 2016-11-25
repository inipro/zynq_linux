#ifndef SPI_H
#define SPI_H

#include <stdint.h>

int spi_init(char *fname);
int spi_release(int spi_fd);
int spi_transfer(int spi_fd, uint8_t *sendBuffer, uint8_t *receiveBuffer, int bytes);

#endif // SPI_H
