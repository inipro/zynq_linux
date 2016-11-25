#!/usr/bin/python

import signal
import time
from gpio import GPIO 

def sig_handler(signum, frame):
	global loop_exit
	if signum == signal.SIGINT:
		loop_exit = 1

signal.signal(signal.SIGINT, sig_handler)
loop_exit = 0

LED_base = 898
leds = [ GPIO(i, 'out') for i in range(LED_base, LED_base+4)]

idx = 0
while True:
	cur_led = leds[idx]
	cur_led.write(1)
	time.sleep(1)
	cur_led.write(0)
	time.sleep(1)
	idx = (idx + 1) % len(leds)
	if loop_exit == 1: break
