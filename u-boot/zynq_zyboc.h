/*
 * (C) Copyright 2012 Xilinx
 * (C) Copyright 2014 Digilent Inc.
 *
 * Configuration for Zynq Development Board - ZYBOC
 * See zynq-common.h for Zynq common configs
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#ifndef __CONFIG_ZYNQ_ZYBOC_H
#define __CONFIG_ZYNQ_ZYBOC_H

#define CONFIG_ZYNQ_I2C0
#define CONFIG_ZYNQ_I2C1
#define CONFIG_SYS_I2C_EEPROM_ADDR_LEN	1
#define CONFIG_CMD_EEPROM
#define CONFIG_ZYNQ_GEM_EEPROM_ADDR	0x50
#define CONFIG_ZYNQ_GEM_I2C_MAC_OFFSET	0xFA
#define CONFIG_DISPLAY
#define CONFIG_I2C_EDID

/* Define ZYBO PS Clock Frequency to 50MHz */
#define CONFIG_ZYNQ_PS_CLK_FREQ	50000000UL

#define CONFIG_EXTRA_ENV_SETTINGS   \
    "loadbootenv_addr=0x2000000\0" \
    "bootenv=uEnv.txt\0" \
    "loadbootenv=load mmc 0 ${loadbootenv_addr} ${bootenv}\0" \
    "importbootenv=echo Importing environment from SD ...; " \
        "env import -t ${loadbootenv_addr} $filesize\0" \
    "sd_uEnvtxt_existence_test=test -e mmc 0 /uEnv.txt\0" \
    "preboot=if test $modeboot = sdboot && env run sd_uEnvtxt_existence_test; " \
            "then if env run loadbootenv; " \
                "then env run importbootenv; " \
            "fi; " \
        "fi; \0"

#include <configs/zynq-common.h>

#endif /* __CONFIG_ZYNQ_ZYBOC_H */
