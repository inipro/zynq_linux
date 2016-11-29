from i2cdev import I2C

class PmodCLS:
	ESC = 0x1B
	BRACKET = ord('[')
	CURSOR_POS_CMD = ord('H')
	DISP_CLR_CMD = ord('j')
	DISP_MODE_CMD = ord('h')
	CURSOR_MODE_CMD = ord('c')
	PRG_CHAR_CMD = ord('p')
	DEF_CHAR_CMD = ord('d')

	LCDS_ERR_SUCCESS = 0 # The action completed successfully
	LCDS_ERR_ARG_ROW_RANGE = 1 # The argument is not within 0, 2 range for rows
	LCDS_ERR_ARG_COL_RANGE = 2 # The argument is not within 0, 39 range
	LCDS_ERR_ARG_POS_RANGE = 9 # The argument is not within 0, 7 range for characters position in the memory

	def __init__(self, bus, address):
		self.i2c = I2C(bus, address)

	def __del__(self):
		self.i2c.close()

	def writeStringAtPos(self, idxRow, idxCol, strLn):
		bResult = PmodCLS.LCDS_ERR_SUCCESS

		if idxRow < 0 or idxRow > 2:
			bResult |= PmodCLS.LCDS_ERR_ARG_ROW_RANGE

		if idxCol < 0 or idxCol > 39:
			bResult |= PmodCLS.LCDS_ERR_ARG_COL_RANGE

		if bResult == PmodCLS.LCDS_ERR_SUCCESS:
			# seperate the position digits in order to send them, useful when the position is greater than 10
			stringToSend = [PmodCLS.ESC, PmodCLS.BRACKET] + map(ord, '%d'%idxRow) + map(ord, ';') + map(ord, '%02d'%idxCol) + [PmodCLS.CURSOR_POS_CMD]
			length = 40 - idxCol if len(strLn) + idxCol > 40 else len(strLn)
			stringToSend.extend(map(ord,strLn))
			self.i2c.write(stringToSend[:7+length])
		return bResult

	def cursorModeSet(self, setCursor, setBlink):

		if not setCursor:
			# send the command for both display and blink off
			self.i2c.write([PmodCLS.ESC, PmodCLS.BRACKET, ord('0'), PmodCLS.CURSOR_MODE_CMD])
		elif setCursor and not setBlink:
			# send the command for display on and blink off
			self.i2c.write([PmodCLS.ESC, PmodCLS.BRACKET, ord('1'), PmodCLS.CURSOR_MODE_CMD])
		else:
			# send the command for display and blink on
			self.i2c.write([PmodCLS.ESC, PmodCLS.BRACKET, ord('2'), PmodCLS.CURSOR_MODE_CMD])

	def displayClear(self):
		self.i2c.write([PmodCLS.ESC, PmodCLS.BRACKET, ord('0'), PmodCLS.DISP_CLR_CMD])

	def displayMode(self, charNumber):

		if charNumber:
			# wrap line at 16 characters
			self.i2c.write([PmodCLS.ESC, PmodCLS.BRACKET, ord('0'), PmodCLS.DISP_MODE_CMD])
		else:
			# wrap line at 40 characters
			self.i2c.write([PmodCLS.ESC, PmodCLS.BRACKET, ord('1'), PmodCLS.DISP_MODE_CMD])

	def defineUserChar(self, strUserDef, charPos):

		if charPos >= 0 and charPos <= 7:
			rgcCmd = [PmodCLS.ESC, PmodCLS.BRACKET]
			for i in range(8):
				rgcCmd.extend(map(ord,'%d;'%strUserDef[i]))
			rgcCmd.extend([ord('%d'%charPos), PmodCLS.DEF_CHAR_CMD, PmodCLS.ESC, PmodCLS.BRACKET, ord('3'), PmodCLS.PRG_CHAR_CMD])
			self.i2c.write(rgcCmd)
			bResult = PmodCLS.LCDS_ERR_SUCCESS
		else:
			bResult = PmodCLS.LCDS_ERR_ARG_POS_RANGE
	
		return bResult
