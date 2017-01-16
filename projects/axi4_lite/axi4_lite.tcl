set project_name axi4_lite
set part_name xc7z010clg400-1
set ip_dir ip
set bd_path $project_name/$project_name.srcs/sources_1/bd/system

file delete -force $project_name

create_project -part $part_name $project_name $project_name

set_property ip_repo_paths $ip_dir [current_project]
update_ip_catalog

create_bd_design system

create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps_0
source axi4_lite_preset.tcl
set_property -dict [apply_preset IPINST] [get_bd_cells ps_0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {
	make_external {FIXED_IO, DDR}
} [get_bd_cells ps_0]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0
connect_bd_intf_net [get_bd_intf_pins ps_0/IIC_0] [get_bd_intf_ports IIC_0]

create_bd_cell -type ip -vlnv hokim:ip:axi_cfg_register:1.0 cfg_0
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/ps_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins cfg_0/S_AXI]
set_property RANGE 64k [get_bd_addr_segs ps_0/Data/SEG_cfg_0_reg0]
set_property offset 0x40000000 [get_bd_addr_segs ps_0/Data/SEG_cfg_0_reg0]

create_bd_cell -type ip -vlnv hokim:ip:axi_sts_register:1.0 sts_0
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/ps_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins sts_0/S_AXI]
set_property RANGE 64k [get_bd_addr_segs ps_0/Data/SEG_sts_0_reg0]
set_property offset 0x40010000 [get_bd_addr_segs ps_0/Data/SEG_sts_0_reg0]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0
set_property -dict [list CONFIG.DIN_WIDTH {1024} CONFIG.DIN_TO {0} CONFIG.DIN_FROM {3}] [get_bd_cells xlslice_0]
connect_bd_net [get_bd_pins xlslice_0/Din] [get_bd_pins cfg_0/cfg_data]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {1} CONFIG.IN0_WIDTH {4}] [get_bd_cells xlconcat_0]
connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins sts_0/sts_data]

create_bd_cell -type ip -vlnv hokim:ip:edge_detect:1.0 edge_detect_0
set_property -dict [list CONFIG.N {4}] [get_bd_cells edge_detect_0]
connect_bd_net [get_bd_pins edge_detect_0/clk] [get_bd_pins ps_0/FCLK_CLK0]
connect_bd_net [get_bd_pins edge_detect_0/edge_detected] [get_bd_pins ps_0/IRQ_F2P]

create_bd_port -dir O -from 3 -to 0 leds
connect_bd_net [get_bd_pins /xlslice_0/Dout] [get_bd_ports leds]

create_bd_port -dir I -from 3 -to 0 sws
connect_bd_net [get_bd_pins /xlconcat_0/In0] [get_bd_ports sws]
connect_bd_net [get_bd_ports sws] [get_bd_pins edge_detect_0/din]


save_bd_design

generate_target all [get_files $bd_path/system.bd]
make_wrapper -files [get_files $bd_path/system.bd] -top

add_files -norecurse $bd_path/hdl/system_wrapper.v

add_files -norecurse -fileset constrs_1 zybo_axi4_lite.xdc

set_property verilog_define {TOOL_VIVADO} [current_fileset]

close_project
