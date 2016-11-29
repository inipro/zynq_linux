#!/usr/bin/python

import signal
import time
from pmodcls_uart import PmodCLS

def sig_handler(signum, frame):
	global loop_exit
	if signum == signal.SIGINT:
		loop_exit = 1

signal.signal(signal.SIGINT, sig_handler)
loop_exit = 0

#cls = PmodCLS('/dev/ttyPS1')
cls = PmodCLS('/dev/ttyUL0')

cls.displayClear()

szInfo1 = "  PmodCLS Demo"
szInfo2 = "  Hello World!"

cls.writeStringAtPos(0, 0, szInfo1)
cls.writeStringAtPos(1, 0, szInfo2)

time.sleep(1)

while True:
	cls.displayClear()

	szInfo1 = "->PmodCLS Demo<- "

	cls.writeStringAtPos(0, 0, szInfo1)
	cls.writeStringAtPos(1, 0, szInfo2)

	time.sleep(1)

	cls.displayClear()

	szInfo1 = "  PmodCLS Demo   "

	cls.writeStringAtPos(0, 0, szInfo1)
	cls.writeStringAtPos(1, 0, szInfo2)

	time.sleep(1)

	if loop_exit == 1: break

