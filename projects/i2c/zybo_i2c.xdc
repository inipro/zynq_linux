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

# Pmod JB Top
set_property IOSTANDARD LVCMOS33 [get_ports iic_ps_*]
# IIC PS SCL 
set_property PACKAGE_PIN T20 [get_ports iic_ps_scl_io]
# IIC PS SDA
set_property PACKAGE_PIN U20 [get_ports iic_ps_sda_io]

# Pmod JB Bottom
set_property IOSTANDARD LVCMOS33 [get_ports iic_pl_*]
# IIC PL SCL
set_property PACKAGE_PIN Y18 [get_ports iic_pl_scl_io]
# IIC PL SDA
set_property PACKAGE_PIN Y19 [get_ports iic_pl_sda_io]
