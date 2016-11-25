## This file is a general .xdc for the ZYBO Rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used signals according to the project

##Audio Codec/external EEPROM IIC bus
#IO_L13P_T2_MRCC_34
set_property PACKAGE_PIN N18 [get_ports iic_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_scl_io]

#IO_L23P_T3_34
set_property PACKAGE_PIN N17 [get_ports iic_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_sda_io]

# Pmod JC Top
set_property IOSTANDARD LVCMOS33 [get_ports spi_ps_*]
# SPI PS CS 0
set_property PACKAGE_PIN V15 [get_ports spi_ps_ss_io]
# SPI PS MOSI
set_property PACKAGE_PIN W15 [get_ports spi_ps_io0_io]
# SPI PS MISO
set_property PACKAGE_PIN T11 [get_ports spi_ps_io1_io]
# SPI PS SCLK
set_property PACKAGE_PIN T10 [get_ports spi_ps_sck_io]

# Pmod JC Bottom
set_property IOSTANDARD LVCMOS33 [get_ports spi_pl_*]
# SPI PL CS 0
set_property PACKAGE_PIN W14 [get_ports spi_pl_ss_io]
# SPI PL MOSI
set_property PACKAGE_PIN Y14 [get_ports spi_pl_io0_io]
# SPI PL MISO
set_property PACKAGE_PIN T12 [get_ports spi_pl_io1_io]
# SPI PL SCLK
set_property PACKAGE_PIN U12 [get_ports spi_pl_sck_io]
