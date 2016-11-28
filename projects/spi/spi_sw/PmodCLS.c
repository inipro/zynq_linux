/* PmodCLS.c	--		Template driver for a Pmod which uses SPI		*/
/*																		*/
/************************************************************************/
/*	Author:		Mikel Skreen											*/
/*	Copyright 2016, Digilent Inc.										*/
/************************************************************************/
/*
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/
/************************************************************************/
/*  File Description:													*/
/*																		*/
/*	This file contains a basic library for the Pmod CLS.				*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/*																		*/
/*	06/15/2016(MikelSkreen): Created									*/
/*																		*/
/************************************************************************/

/***************************** Include Files ****************************/
#include "PmodCLS.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "spi.h"

static int spi_fd;

/************************** Function Definitions ************************/

/* --------------------------------------------------------------------*/
/*** uint8_t  CLS_WriteStringAtPos
**
**	Parameters:
**		idxLine - the line where the string is written: 0 or 1
**		idxPos  - the start column for the string to be written:0 to 39
**		strLn   - the string to be written
**
**	Return Value:
**		u8
**				- LCDS_ERR_SUCCESS - The action completed successfully
**				- a combination of the following errors(OR-ed):
**				- LCDS_ERR_ARG_COL_RANGE - The argument is not within 0, 39 range
**				- LCDS_ERR_ARG_ROW_RANGE - The argument is not within 0, 2 range
**
**	Errors:
**		see returned values
**
**	Description:
**		This function writes a string at a specified position
**
-----------------------------------------------------------------------*/
uint8_t CLS_WriteStringAtPos(uint8_t idxRow, uint8_t idxCol, char* strLn) {

	uint8_t bResult = LCDS_ERR_SUCCESS;
	if (idxRow < 0 || idxRow > 2){
		bResult |= LCDS_ERR_ARG_ROW_RANGE;
	}
	if (idxCol < 0 || idxCol > 39){
		bResult |= LCDS_ERR_ARG_COL_RANGE;
	}
	if (bResult == LCDS_ERR_SUCCESS){
		//separate the position digits in order to send them, useful when the position is greater than 10
		uint8_t firstDigit 		= idxCol % 10;
		uint8_t secondDigit 	= idxCol / 10;
		uint8_t length 			= strlen(strLn);
		uint8_t lengthToPrint   = length + idxCol;
		uint8_t stringToSend[]  = {ESC, BRACKET, idxRow + '0', ';', secondDigit + '0', firstDigit + '0', CURSOR_POS_CMD};
		if (lengthToPrint > 40) {
			//truncate the length of the string
			//if it's greater than the positions number of a line
			length = 40 - idxCol;
		}
		spi_transfer(spi_fd, stringToSend, NULL, 7);
		spi_transfer(spi_fd, strLn, NULL, length);
	}
	return bResult;
}

/* --------------------------------------------------------------------*/
/** CLS_CursorModeSet
**
**	Parameters:
**		setCursor - boolean parameter through which the cursor is set on or off
**		setBlink - boolean parameter through which the blink option is set on or off
**
**	Return Value:
**		None
**
**	Errors:
**		none
**
**	Description:
**		This function turns the cursor and the blinking option on or off,
**    according to the user's selection.
-----------------------------------------------------------------------*/
void CLS_CursorModeSet(bool setCursor, bool setBlink) {
	uint8_t cursorOff[]			  = {ESC, BRACKET, '0', CURSOR_MODE_CMD};
	uint8_t cursorOnBlinkOff[]    = {ESC, BRACKET, '1', CURSOR_MODE_CMD};
	uint8_t cursorBlinkOn[]       = {ESC, BRACKET, '2', CURSOR_MODE_CMD};
	if (!setCursor)	{
		//send the command for both display and blink off
		spi_transfer(spi_fd, cursorOff, NULL, 4);
	}
	else if ((setCursor)&&(!setBlink)) {
		//send the command for display on and blink off
		spi_transfer(spi_fd, cursorOnBlinkOff, NULL, 4);
	}
	else {
		//send the command for display and blink on
		spi_transfer(spi_fd, cursorBlinkOn, NULL, 4);
	}
}

/* ------------------------------------------------------------------- */
/** CLS_DisplayClear
**
**	Parameters:
**		none
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		This function clears the display and returns the cursor home
-----------------------------------------------------------------------*/
void CLS_DisplayClear() {
	uint8_t dispClr[] = {ESC, BRACKET, '0', DISP_CLR_CMD};
	//clear the display and returns the cursor home
	spi_transfer(spi_fd, dispClr, NULL, 4);
}

/* --------------------------------------------------------------------*/
/** CLS_DisplayMode
**
**	Parameters:
**		charNumber - parameter for selecting the wrapping type of the line: to 16 or 40 characters
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		This function wraps the line at 16 or 40 characters
-----------------------------------------------------------------------*/
void CLS_DisplayMode(bool charNumber){
	uint8_t dispMode16[] = {ESC, BRACKET, '0', DISP_MODE_CMD};
	uint8_t dispMode40[] = {ESC, BRACKET, '1', DISP_MODE_CMD};
	if (charNumber){
		//wrap line at 16 characters
		spi_transfer(spi_fd, dispMode16, NULL, 4);
	}
	else{
		//wrap line at 40 characters
		spi_transfer(spi_fd, dispMode40, NULL, 4);
	}
}

/* --------------------------------------------------------------------*/
/** CLS_BuildUserDefChar
**
**	Parameters:
**		strUserDef - bytes array containing the values to be converted in values that are recognized by the firmware
**		cmdStr	   - characters array containing the values converted
**
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		This function builds the string to be converted in an interpretable array of chars for the LCD
-----------------------------------------------------------------------*/
void CLS_BuildUserDefChar(uint8_t* strUserDef, char* cmdStr) {
	uint8_t len = 8;
	int i;
	char elStr[4];
	//print the bytes from the input array as hex values
	for(i = 0; i < len; i++){
		sprintf(elStr, "%d;", strUserDef[i]);
		strcat(cmdStr, elStr);
	}
}

/* --------------------------------------------------------------------*/
/** CLS_DefineUserChar
**
**	Parameters:
**		strUserDef - characters array containing the numerical value of each row in the char
**		charPos - the position of the character saved in the memory
**
**
**	Return Value:
**		uint8_t
**					- LCDS_ERR_SUCCESS - The action completed successfully
**					- LCDS_ERR_ARG_POS_RANGE - The argument is not within 0, 7 range
**
**	Errors:
**		none
**
**	Description:
**		This function saves a user defined char in the RAM memory
**
-----------------------------------------------------------------------*/
uint8_t CLS_DefineUserChar(uint8_t* strUserDef, uint8_t charPos) {
	uint8_t rgcCmd[MAX];
	uint8_t bResult;
	if (charPos >= 0 && charPos <= 7){
		rgcCmd[0] = ESC;
		rgcCmd[1] = BRACKET;
		rgcCmd[2] = 0;
		//build the values to be sent for defining the custom character
		CLS_BuildUserDefChar(strUserDef, rgcCmd + 2);
		uint8_t bLength = strlen(rgcCmd);
		rgcCmd[bLength++] = (char)charPos + '0';
		rgcCmd[bLength++] = DEF_CHAR_CMD;
		//save the defined character in the RAM
		rgcCmd[bLength++] = ESC;
		rgcCmd[bLength++] = BRACKET;
		rgcCmd[bLength++] = '3';
		rgcCmd[bLength++] = PRG_CHAR_CMD;
		spi_transfer(spi_fd, rgcCmd, NULL, bLength);
		bResult = LCDS_ERR_SUCCESS;
	}
	else {
		bResult = LCDS_ERR_ARG_POS_RANGE;
	}
	return bResult;
}

/*---------------------------------------------------------------------*/
/***	void CLS_begin(char *devname)
**
**	Parameters:
**		devname: The name of the PmodCLS SPI device
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Initialize the PmodCLS.
-----------------------------------------------------------------------*/
void CLS_begin(char *devname)
{
	spi_fd = spi_init(devname);
}

/*---------------------------------------------------------------------*/
/***	CLS_end(void)
**
**	Parameters:
**		InstancePtr		- PmodCLS object to stop
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		Stops the device
-----------------------------------------------------------------------*/
void CLS_end(){
	spi_release(spi_fd);
}
