#include <stdint.h>

int uart_init(char *fname);

int uart_release(int uart_fd);

int uart_read(int uart_fd, uint8_t *buffer, int bytes);

int uart_write(int uart_fd, uint8_t *buffer, int bytes);
