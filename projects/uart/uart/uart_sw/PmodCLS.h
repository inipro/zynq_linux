#ifndef PMODCLS_H
#define PMODCLS_H


#include <stdint.h>

/* ------------------------------------------------------------ */
/*					Definitions									*/
/* ------------------------------------------------------------ */
#define bool uint8_t
#define true 1
#define false 0

//#define LCDS_H
//commands for the display list
#define ESC 					0x1B
#define BRACKET					0x5B //[
#define CURSOR_POS_CMD			0x48 //H
#define CURSOR_SAVE_CMD			0x73 //s
#define CURSOR_RSTR_CMD			0x75 //u
#define DISP_CLR_CMD			0x6A //j
#define ERASE_INLINE_CMD		0x4B //K
#define ERASE_FIELD_CMD			0x4E //N
#define LSCROLL_CMD				0x40 //@
#define RSCROLL_CMD				0x41 //A
#define RST_CMD					0x2A //*
#define DISP_EN_CMD				0x65 //e
#define DISP_MODE_CMD			0x68 //h
#define CURSOR_MODE_CMD			0x63 //c
#define TWI_SAVE_ADDR_CMD		0x61 //a
#define BR_SAVE_CMD				0x62 //b
#define PRG_CHAR_CMD			0x70 //p
#define SAVE_RAM_TO_EEPROM_CMD	0x74 //t
#define LD_EEPROM_TO_RAM_CMD	0x6C //l
#define DEF_CHAR_CMD			0x64 //d
#define COMM_MODE_SAVE_CMD		0x6D //m
#define EEPROM_WR_EN_CMD		0x77 //w
#define CURSOR_MODE_SAVE_CMD	0x6E //n
#define DISP_MODE_SAVE_CMD		0x6F //o

/* ------------------------------------------------------------ */
/*					Errors Definitions							*/
/* ------------------------------------------------------------ */
#define LCDS_ERR_SUCCESS			0	// The action completed successfully
#define LCDS_ERR_ARG_ROW_RANGE		1	// The argument is not within 0, 2 range for rows
#define LCDS_ERR_ARG_COL_RANGE		2	// The argument is not within 0, 39 range
#define LCDS_ERR_ARG_ERASE_OPTIONS	3	// The argument is not within 0, 2 range for erase types
#define LCDS_ERR_ARG_BR_RANGE		4	// The argument is not within 0, 6 range
#define LCDS_ERR_ARG_TABLE_RANGE	5	// The argument is not within 0, 3 range for table selection
#define LCDS_ERR_ARG_COMM_RANGE		6	// The argument is not within 0, 7 range
#define LCDS_ERR_ARG_CRS_RANGE		7	// The argument is not within 0, 2 range for cursor modes
#define LCDS_ERR_ARG_DSP_RANGE		8	// The argument is not within 0, 3 range for display settings types
#define LCDS_ERR_ARG_POS_RANGE		9	// The argument is not within 0, 7 range for characters position in the memory

//other defines used for library functions
#define MAX						150
/* ------------------------------------------------------------ */
/*		Register addresses Definitions							*/
/* ------------------------------------------------------------ */

/* ------------------------------------------------------------ */
/*				Bit masks Definitions							*/
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */
/*				Parameters Definitions							*/
/* ------------------------------------------------------------ */



/* ------------------------------------------------------------ */
/*					Procedure Declarations						*/
/* ------------------------------------------------------------ */

uint8_t CLS_WriteStringAtPos(uint8_t idxRow, uint8_t idxCol, char* strLn);
void CLS_CursorModeSet(bool setCursor, bool setBlink);
void CLS_DisplayClear();
void CLS_DisplayMode(bool charNumber);
void CLS_BuildUserDefChar(uint8_t* strUserDef, char* cmdStr);
uint8_t CLS_DefineUserChar(uint8_t* strUserDef, uint8_t charPos);

void CLS_begin(char *devname);
void CLS_end();

#endif // PMODCLS_H
