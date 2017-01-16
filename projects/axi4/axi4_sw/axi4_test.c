#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>

#define CONTROL_REG			0x0
#define PACKETIZER_REG		0x4
#define RAM_READER_REG		0x8
#define RAM_WRITER_REG		0xC

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

int main()
{
	int cfg0_fd, sts0_fd, ram_reader0_fd, ram_writer0_fd;
	void *cfg0, *sts0, *ram_reader0, *ram_writer0;
	uint32_t cfg0_size, sts0_size, ram_reader0_size, ram_writer0_size;

	if ((cfg0_fd = open("/dev/uio0", O_RDWR)) < 0) {
		perror("open cfg0");
		return -1;
	}

	if ((sts0_fd = open("/dev/uio1", O_RDWR)) < 0) {
		perror("open sts0");
		return -1;
	}

	if ((ram_reader0_fd = open("/dev/uio2", O_RDWR)) < 0) {
		perror("open ram_reader0");
		return -1;
	}

	if ((ram_writer0_fd = open("/dev/uio3", O_RDWR)) < 0) {
		perror("open ram_writer0");
		return -1;
	}

	cfg0_size = get_memory_size("/sys/class/uio/uio0/maps/map0/size");
	sts0_size = get_memory_size("/sys/class/uio/uio1/maps/map0/size");
	ram_reader0_size = get_memory_size("/sys/class/uio/uio2/maps/map0/size");
	ram_writer0_size = get_memory_size("/sys/class/uio/uio3/maps/map0/size");

	cfg0 = mmap(NULL, cfg0_size, PROT_READ|PROT_WRITE, MAP_SHARED, cfg0_fd, 0);

	if (cfg0 == MAP_FAILED) {
		perror("cfg0 mmap call failure");
		return -1;
	}

	sts0 = mmap(NULL, sts0_size, PROT_READ|PROT_WRITE, MAP_SHARED, sts0_fd, 0);

	if (sts0 == MAP_FAILED) {
		perror("sts0 mmap call failure");
		return -1;
	}

	ram_reader0 = mmap(NULL, ram_reader0_size, PROT_READ|PROT_WRITE, MAP_SHARED, ram_reader0_fd, 0);

	if (ram_reader0 == MAP_FAILED) {
		perror("ram_reader0 mmap call failure");
		return -1;
	}

	ram_writer0 = mmap(NULL, ram_writer0_size, PROT_READ|PROT_WRITE, MAP_SHARED, ram_writer0_fd, 0);

	if (ram_writer0 == MAP_FAILED) {
		perror("ram_writer0 mmap call failure");
		return -1;
	}

	uio_write(cfg0, RAM_READER_REG, 0x1E000000);
	uio_write(cfg0, RAM_WRITER_REG, 0x1F000000);
	uio_write(cfg0, PACKETIZER_REG, 512);

	for(int i=0; i<1026; i++) {
		uio_write(ram_reader0, i*4, i);
		uio_write(ram_writer0, i*4, 0);
	}

	printf("before...\n");
	for(int i=0; i<1026; i++) {
		printf("i = %d, src = %d, dst = %d\n", i, uio_read(ram_reader0, i*4),
			uio_read(ram_writer0, i*4));
	}

	uio_write(cfg0, CONTROL_REG, 0);
	uio_write(cfg0, CONTROL_REG, uio_read(cfg0, CONTROL_REG) | 0x1);
	uio_write(cfg0, CONTROL_REG, uio_read(cfg0, CONTROL_REG) | 0x2);

	printf("after...\n");
	for(int i=0; i<1026; i++) {
		printf("i = %d, src = %d, dst = %d\n", i, uio_read(ram_reader0, i*4),
			uio_read(ram_writer0, i*4));
	}

	munmap(cfg0, cfg0_size);
	munmap(sts0, sts0_size);
	munmap(ram_reader0, ram_reader0_size);
	munmap(ram_writer0, ram_writer0_size);

	return 0;
}
