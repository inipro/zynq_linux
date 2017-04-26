set project_name qspi
set part_name xc7z010clg400-1
#set ip_dir ip
set bd_path $project_name/$project_name.srcs/sources_1/bd/system

file delete -force $project_name

create_project -part $part_name $project_name $project_name

#set_property ip_repo_paths $ip_dir [current_project]
#update_ip_catalog

create_bd_design system

create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps_0
source qspi_preset.tcl
set_property -dict [apply_preset IPINST] [get_bd_cells ps_0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {
	make_external {FIXED_IO, DDR}
} [get_bd_cells ps_0]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0

connect_bd_intf_net [get_bd_intf_pins ps_0/IIC_0] [get_bd_intf_ports IIC_0]

generate_target all [get_files $bd_path/system.bd]
make_wrapper -files [get_files $bd_path/system.bd] -top

add_files -norecurse $bd_path/hdl/system_wrapper.v

add_files -norecurse -fileset constrs_1 zybo_qspi.xdc

set_property verilog_define {TOOL_VIVADO} [current_fileset]

close_project
