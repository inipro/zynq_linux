#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

#define GPIO_DATA_OFFSET	0x0		/* Data register for 1st channel */
#define GPIO_TRI_OFFSET		0x4		/* I/O direction reg for 1st channel */
#define GPIO_DATA2_OFFSET	0x8		/* Data register for 2nd channel */
#define GPIO_TRI2_OFFSET	0xC		/* I/O direction reg for 2nd channel */
#define GPIO_GIE_OFFSET		0x11C	/* Global interrupt enable register */
#define GPIO_ISR_OFFSET		0x120	/* Interrupt status register */
#define GPIO_IER_OFFSET		0x128	/* Interrupt enable register */

void gpio_write(void *gpio_base, uint32_t offset, uint32_t value)
{
	*((volatile unsigned *)(gpio_base + offset)) = value;
}

uint32_t gpio_read(void *gpio_base, uint32_t offset)
{
	return *((volatile unsigned *)(gpio_base + offset));
}

uint32_t get_memory_size(char *sysfs_path_file)
{
	FILE *size_fp;
	uint32_t size;

	// open the file that describes the memory range size that is based on the
	// reg property of the node in the device tree
	size_fp = fopen(sysfs_path_file, "r");

	if (!size_fp) {
		printf("unable to open the uio size file\n");
		exit(-1);
	}

	// get the size which is an ASCII string such as 0xXXXXXXXX and then be stop
	// using the file
	fscanf(size_fp, "0x%08X", &size);
	fclose(size_fp);

	return size;
}

void wait_for_interrupt(int fd, void *gpio_ptr)
{
	int pending = 0;
	int reenable = 1;
	uint32_t reg;

	// block on the file waiting for an interrupt
	read(fd, (void *)&pending, sizeof(int));
	//printf("Interrupt!\n");

	// the interrupt occurred for the 1st GPIO channel so clear it
	reg = gpio_read(gpio_ptr, GPIO_ISR_OFFSET);
	if (reg) gpio_write(gpio_ptr, GPIO_ISR_OFFSET, 1);

	// re-enable the interrupt in the interrupt controller thru
	// the UIO subsystem now that it's been handled

	write(fd, (void *)&reenable, sizeof(int));
}

int main()
{
	int uio0_fd, uio1_fd;
	void *ptr0;
	void *ptr1;
	uint32_t gpio_size0, gpio_size1;
	int reenable = 1;
	uint32_t value;

	if ((uio0_fd = open("/dev/uio0", O_RDWR)) < 0) {
		perror("open uio0");
	} 

	if ((uio1_fd = open("/dev/uio1", O_RDWR)) < 0) {
		perror("open uio1");
	}

	gpio_size0 = get_memory_size("/sys/class/uio/uio0/maps/map0/size");
	gpio_size1 = get_memory_size("/sys/class/uio/uio1/maps/map0/size");

	ptr0 =  mmap(NULL, gpio_size0, PROT_READ|PROT_WRITE, MAP_SHARED, uio0_fd, 0);

	if (ptr0 == MAP_FAILED) {
		perror("uio0 mmap call failure\n");
		return -1;
	}

	ptr1 =  mmap(NULL, gpio_size1, PROT_READ|PROT_WRITE, MAP_SHARED, uio1_fd, 0);

	if (ptr1 == MAP_FAILED) {
		perror("uio1 mmap call failure\n");
		return -1;
	}

	gpio_write(ptr0, GPIO_TRI_OFFSET, 0x0); // GPIO Channel 1 input

	gpio_write(ptr1, GPIO_TRI_OFFSET, 0xF); // GPIO Channel 1 input
	gpio_write(ptr1, GPIO_GIE_OFFSET, 0x80000000); // GIER, 31st Bit
	gpio_write(ptr1, GPIO_IER_OFFSET, 1); // interrupt enable

	write(uio1_fd, (void*)&reenable, sizeof(int));
	while (1)
	{
		wait_for_interrupt(uio1_fd, ptr1);
		value = gpio_read(ptr1, GPIO_DATA_OFFSET);
		//printf("sws = 0x%0X\n", value);
		gpio_write(ptr0, GPIO_DATA_OFFSET, value);
	}

	munmap(ptr0, gpio_size0);
	munmap(ptr1, gpio_size1);

	return 0;
}
