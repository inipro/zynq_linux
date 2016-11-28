#include <stdint.h>

int iic_init(char *fname, uint8_t addr);

int iic_release(int iic_fd);

int iic_read(int iic_fd, uint8_t *buffer, int bytes);

int iic_write(int iic_fd, uint8_t *buffer, int bytes);
