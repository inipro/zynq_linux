#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

#define DATA_OFFSET	0x0		/* Data register for cfg and sts */

void uio_write(void *uio_base, uint32_t offset, uint32_t value)
{
	*((volatile uint32_t *)(uio_base + offset)) = value;
}

uint32_t uio_read(void *uio_base, uint32_t offset)
{
	return *((volatile uint32_t *)(uio_base + offset));
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

void wait_for_interrupt(int fd)
{
	int pending = 0;
	int reenable = 1;
	uint32_t reg;

	// block on the file waiting for an interrupt
	read(fd, (void *)&pending, sizeof(int));
	//printf("Interrupt!\n");

	// re-enable the interrupt in the interrupt controller thru
	// the UIO subsystem now that it's been handled

	write(fd, (void *)&reenable, sizeof(int));
}

int main()
{
	int cfg0_fd, sts0_fd;
	void *cfg0;
	void *sts0;
	uint32_t cfg0_size, sts0_size;
	int reenable = 1;
	uint32_t value;

	if ((cfg0_fd = open("/dev/uio0", O_RDWR)) < 0) {
		perror("open cfg0");
		return -1;
	} 

	if ((sts0_fd = open("/dev/uio1", O_RDWR)) < 0) {
		perror("open sts0");
		return -1;
	}

	cfg0_size = get_memory_size("/sys/class/uio/uio0/maps/map0/size");
	sts0_size = get_memory_size("/sys/class/uio/uio1/maps/map0/size");

	cfg0 =  mmap(NULL, cfg0_size, PROT_READ|PROT_WRITE, MAP_SHARED, cfg0_fd, 0);

	if (cfg0 == MAP_FAILED) {
		perror("cfg0 mmap call failure");
		return -1;
	}

	sts0 =  mmap(NULL, sts0_size, PROT_READ|PROT_WRITE, MAP_SHARED, sts0_fd, 0);

	if (sts0 == MAP_FAILED) {
		perror("sts0 mmap call failure");
		return -1;
	}

	write(sts0_fd, (void *)&reenable, sizeof(int));
	while (1)
	{
		wait_for_interrupt(sts0_fd);
		value = uio_read(sts0, DATA_OFFSET);
		printf("sws = 0x%0X\n", value);
		uio_write(cfg0, DATA_OFFSET, value);
	}

	munmap(cfg0, cfg0_size);
	munmap(sts0, sts0_size);

	return 0;
}
