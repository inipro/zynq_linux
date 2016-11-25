set project_name spi
set part_name xc7z010clg400-1
#set ip_dir ip
set bd_path $project_name/$project_name.srcs/sources_1/bd/system

file delete -force $project_name

create_project -part $part_name $project_name $project_name

#set_property ip_repo_paths $ip_dir [current_project]
#update_ip_catalog

create_bd_design system

create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps_0
source spi_preset.tcl
set_property -dict [apply_preset IPINST] [get_bd_cells ps_0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {
	make_external {FIXED_IO, DDR}
} [get_bd_cells ps_0]


create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 spi_ps
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:spi_rtl:1.0 spi_pl

create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_0

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 spi_0
set_property -dict [list CONFIG.C_USE_STARTUP {0} CONFIG.C_USE_STARTUP_INT {0} CONFIG.Multiples16 {128}  CONFIG.C_NUM_SS_BITS {1}] [get_bd_cells spi_0]

connect_bd_intf_net [get_bd_intf_pins ps_0/IIC_0] [get_bd_intf_ports IIC_0]
connect_bd_intf_net [get_bd_intf_pins ps_0/SPI_0] [get_bd_intf_ports spi_ps]
connect_bd_intf_net [get_bd_intf_pins spi_0/SPI_0] [get_bd_intf_ports spi_pl]
connect_bd_net [get_bd_pins spi_0/ext_spi_clk] [get_bd_pins ps_0/FCLK_CLK0]
connect_bd_net [get_bd_pins spi_0/ip2intc_irpt] [get_bd_pins ps_0/IRQ_F2P]

apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {
	    Master /ps_0/M_AXI_GP0
			    Clk Auto
} [get_bd_intf_pins spi_0/AXI_LITE]

set_property RANGE 4K [get_bd_addr_segs ps_0/Data/SEG_spi_0_Reg]
set_property OFFSET 0x40000000 [get_bd_addr_segs ps_0/Data/SEG_spi_0_Reg]

generate_target all [get_files $bd_path/system.bd]
make_wrapper -files [get_files $bd_path/system.bd] -top

file copy -force system_wrapper.v $bd_path/hdl/system_wrapper.v

add_files -norecurse $bd_path/hdl/system_wrapper.v

add_files -norecurse -fileset constrs_1 zybo_spi.xdc

set_property verilog_define {TOOL_VIVADO} [current_fileset]

close_project
