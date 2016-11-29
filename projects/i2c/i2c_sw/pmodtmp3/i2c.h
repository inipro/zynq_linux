#include <stdint.h>

int i2c_init(char *fname, uint8_t addr);

int i2c_release(int i2c_fd);

int i2c_read(int i2c_fd, uint8_t *buffer, int bytes);

int i2c_write(int i2c_fd, uint8_t *buffer, int bytes);
