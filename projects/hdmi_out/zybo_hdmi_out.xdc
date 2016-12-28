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

##HDMI Signals
#IO_L13N_T2_MRCC_35
set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_n]

#IO_L13P_T2_MRCC_35
set_property PACKAGE_PIN H16 [get_ports TMDS_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports TMDS_clk_p]

#IO_L4N_T0_35
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[0]}]

#IO_L4P_T0_35
set_property PACKAGE_PIN D19 [get_ports {TMDS_data_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[0]}]

#IO_L1N_T0_AD0N_35
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[1]}]

#IO_L1P_T0_AD0P_35
set_property PACKAGE_PIN C20 [get_ports {TMDS_data_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[1]}]

#IO_L2N_T0_AD8N_35
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_n[2]}]

#IO_L2P_T0_AD8P_35
set_property PACKAGE_PIN B19 [get_ports {TMDS_data_p[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {TMDS_data_p[2]}]

#IO_L5P_T0_AD9P_35
#set_property PACKAGE_PIN E18 [get_ports {hdmi_hpd_tri_i[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_hpd_tri_i[0]}]

##IO_L6N_T0_VREF_35
set_property PACKAGE_PIN F17 [get_ports {HDMI_OEN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HDMI_OEN[0]}]

#IO_L16P_T2_35
set_property PACKAGE_PIN G17 [get_ports hdmi_ddc_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_ddc_scl_io]

#IO_L16N_T2_35
set_property PACKAGE_PIN G18 [get_ports hdmi_ddc_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_ddc_sda_io]

