set project_name gpio
set part_name xc7z010clg400-1
#set ip_dir ip
set bd_path $project_name/$project_name.srcs/sources_1/bd/system

file delete -force $project_name

create_project -part $part_name $project_name $project_name

#set_property ip_repo_paths $ip_dir [current_project]
#update_ip_catalog

create_bd_design system

create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps_0
source gpio_preset.tcl
set_property -dict [apply_preset IPINST] [get_bd_cells ps_0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {
	make_external {FIXED_IO, DDR}
} [get_bd_cells ps_0]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 leds_o
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 btns_i
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 sws_i

create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_0

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 leds_4Bits
set_property -dict [list CONFIG.C_GPIO_WIDTH {4} CONFIG.C_ALL_INPUTS {0} CONFIG.C_INTERRUPT_PRESENT {1} CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells leds_4Bits]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 btns_4Bits
set_property -dict [list CONFIG.C_GPIO_WIDTH {4} CONFIG.C_ALL_INPUTS {1} CONFIG.C_INTERRUPT_PRESENT {1} CONFIG.C_ALL_OUTPUTS {0}] [get_bd_cells btns_4Bits]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 sws_4Bits
set_property -dict [list CONFIG.C_GPIO_WIDTH {4} CONFIG.C_ALL_INPUTS {1} CONFIG.C_INTERRUPT_PRESENT {1} CONFIG.C_ALL_OUTPUTS {0}] [get_bd_cells sws_4Bits]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_0
set_property -dict [list CONFIG.NUM_PORTS {3}] [get_bd_cells concat_0]


connect_bd_intf_net [get_bd_intf_pins ps_0/IIC_0] [get_bd_intf_ports IIC_0]
connect_bd_net [get_bd_pins leds_4Bits/ip2intc_irpt] [get_bd_pins concat_0/In2]
connect_bd_net [get_bd_pins btns_4Bits/ip2intc_irpt] [get_bd_pins concat_0/In1]
connect_bd_net [get_bd_pins sws_4Bits/ip2intc_irpt] [get_bd_pins concat_0/In0]
connect_bd_net [get_bd_pins ps_0/IRQ_F2P] [get_bd_pins concat_0/dout]
connect_bd_intf_net [get_bd_intf_pins leds_4Bits/GPIO] [get_bd_intf_ports leds_o]
connect_bd_intf_net [get_bd_intf_pins btns_4Bits/GPIO] [get_bd_intf_ports btns_i]
connect_bd_intf_net [get_bd_intf_pins sws_4Bits/GPIO] [get_bd_intf_ports sws_i]

apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
		    Master /ps_0/M_AXI_GP0
						    Clk Auto

} [get_bd_intf_pins leds_4Bits/S_AXI]

set_property RANGE 4K [get_bd_addr_segs ps_0/Data/SEG_leds_4Bits_Reg]
set_property OFFSET 0x40000000 [get_bd_addr_segs ps_0/Data/SEG_leds_4Bits_Reg]

apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
		    Master /ps_0/M_AXI_GP0
						    Clk Auto

} [get_bd_intf_pins btns_4Bits/S_AXI]

set_property RANGE 4K [get_bd_addr_segs ps_0/Data/SEG_btns_4Bits_Reg]
set_property OFFSET 0x40001000 [get_bd_addr_segs ps_0/Data/SEG_btns_4Bits_Reg]

apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
		    Master /ps_0/M_AXI_GP0
						    Clk Auto

} [get_bd_intf_pins sws_4Bits/S_AXI]

set_property RANGE 4K [get_bd_addr_segs ps_0/Data/SEG_sws_4Bits_Reg]
set_property OFFSET 0x40002000 [get_bd_addr_segs ps_0/Data/SEG_sws_4Bits_Reg]


generate_target all [get_files $bd_path/system.bd]
make_wrapper -files [get_files $bd_path/system.bd] -top

add_files -norecurse $bd_path/hdl/system_wrapper.v

add_files -norecurse -fileset constrs_1 zybo_gpio.xdc

set_property verilog_define {TOOL_VIVADO} [current_fileset]

close_project
