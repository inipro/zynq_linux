import io
import fcntl


class I2C:

	IOCTL_I2C_SLAVE = 0x0703

	def __init__(self, bus, address):
		self.fr = io.open("/dev/i2c-"+str(bus), "rb", buffering=0)
		self.fw = io.open("/dev/i2c-"+str(bus), "wb", buffering=0)

		# set device address

		fcntl.ioctl(self.fr, I2C.IOCTL_I2C_SLAVE, address)
		fcntl.ioctl(self.fw, I2C.IOCTL_I2C_SLAVE, address)

	def close(self):
		self.fw.close()
		self.fr.close()

	def write(self, data):
		self.fw.write(bytearray(data))

	def read(self, num):
		return bytearray(self.fr.read(num))
