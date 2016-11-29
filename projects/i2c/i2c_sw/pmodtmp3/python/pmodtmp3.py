#!/usr/bin/python

import signal
import time
from i2cdev import I2C

def sig_handler(signum, frame):
	global loop_exit
	if signum == signal.SIGINT:
		loop_exit = 1

signal.signal(signal.SIGINT, sig_handler)
loop_exit = 0

#i2c = I2C(1, 0x48)
i2c = I2C(2, 0x48)

while True:
	i2c.write([0x0])
	dat = i2c.read(2)

	_temp = dat[1] | (dat[0] << 8)
	if dat[0] & 0x80 == 0:
		temp = _temp / 256.0
	else:
		temp = -1 *(~_temp + 1) / 256.0

	print('temp = %g'% temp)

	time.sleep(1)

	if loop_exit == 1: break
	
i2c.close()
