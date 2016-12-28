set project_name hdmi_out
set part_name xc7z010clg400-1
set ip_dir ip
set bd_path $project_name/$project_name.srcs/sources_1/bd/system

file delete -force $project_name

create_project -part $part_name $project_name $project_name

set_property ip_repo_paths $ip_dir [current_project]
update_ip_catalog

create_bd_design system

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 HDMI_DDC
#create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 HDMI_HPD
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0
create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS

create_bd_port -dir O -from 0 -to 0 HDMI_OEN

create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps_0
source hdmi_out_preset.tcl
set_property -dict [apply_preset IPINST] [get_bd_cells ps_0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {
	    make_external {FIXED_IO, DDR}
} [get_bd_cells ps_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon 
set_property -dict [ list \
CONFIG.NUM_MI {1} \
] [get_bd_cells axi_mem_intercon]

source hier_hdmi_out.tcl
create_hier_cell_hdmi_out [current_bd_instance .] hdmi_out_0

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps_0_axi_periph
set_property -dict [ list \
CONFIG.NUM_MI {3} \
] [get_bd_cells ps_0_axi_periph]

create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_0
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_1

connect_bd_intf_net [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins ps_0/S_AXI_HP0]
  connect_bd_intf_net [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins hdmi_out_0/M_AXI_MM2S]
connect_bd_intf_net [get_bd_intf_ports IIC_0] [get_bd_intf_pins ps_0/IIC_0]
connect_bd_intf_net [get_bd_intf_ports HDMI_DDC] [get_bd_intf_pins ps_0/IIC_1]
connect_bd_intf_net [get_bd_intf_pins ps_0/M_AXI_GP0] [get_bd_intf_pins ps_0_axi_periph/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins hdmi_out_0/S_AXI_LITE] [get_bd_intf_pins ps_0_axi_periph/M00_AXI]
connect_bd_intf_net [get_bd_intf_pins hdmi_out_0/s00_axi] [get_bd_intf_pins ps_0_axi_periph/M01_AXI]
connect_bd_intf_net [get_bd_intf_pins hdmi_out_0/ctrl] [get_bd_intf_pins ps_0_axi_periph/M02_AXI]
connect_bd_intf_net [get_bd_intf_ports TMDS] [get_bd_intf_pins hdmi_out_0/TMDS]

connect_bd_net [get_bd_pins hdmi_out_0/s00_axi_aclk] [get_bd_pins ps_0/FCLK_CLK0] [get_bd_pins ps_0/M_AXI_GP0_ACLK] [get_bd_pins ps_0_axi_periph/ACLK] [get_bd_pins ps_0_axi_periph/M00_ACLK] [get_bd_pins ps_0_axi_periph/M01_ACLK] [get_bd_pins ps_0_axi_periph/M02_ACLK] [get_bd_pins ps_0_axi_periph/S00_ACLK] [get_bd_pins rst_0/slowest_sync_clk]
connect_bd_net [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins hdmi_out_0/m_axis_mm2s_aclk] [get_bd_pins ps_0/FCLK_CLK1] [get_bd_pins ps_0/S_AXI_HP0_ACLK] [get_bd_pins rst_1/slowest_sync_clk]
connect_bd_net [get_bd_pins ps_0/FCLK_RESET0_N] [get_bd_pins rst_0/ext_reset_in] [get_bd_pins rst_1/ext_reset_in]
connect_bd_net [get_bd_pins ps_0_axi_periph/ARESETN] [get_bd_pins rst_0/interconnect_aresetn]
connect_bd_net [get_bd_pins hdmi_out_0/s00_axi_aresetn] [get_bd_pins ps_0_axi_periph/M00_ARESETN] [get_bd_pins ps_0_axi_periph/M01_ARESETN] [get_bd_pins ps_0_axi_periph/M02_ARESETN] [get_bd_pins ps_0_axi_periph/S00_ARESETN] [get_bd_pins rst_0/peripheral_aresetn]
connect_bd_net [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins rst_1/interconnect_aresetn]
connect_bd_net [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins rst_1/peripheral_aresetn]
connect_bd_net [get_bd_pins hdmi_out_0/dout] [get_bd_pins ps_0/IRQ_F2P]
connect_bd_net [get_bd_ports HDMI_OEN] [get_bd_pins hdmi_out_0/dout1]

assign_bd_address [get_bd_addr_segs hdmi_out_0/axi_vdma_0/S_AXI_LITE/Reg]
set_property RANGE 64K [get_bd_addr_segs ps_0/Data/SEG_axi_vdma_0_Reg]
set_property OFFSET 0x40000000 [get_bd_addr_segs ps_0/Data/SEG_axi_vdma_0_Reg]

assign_bd_address [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM]

assign_bd_address [get_bd_addr_segs hdmi_out_0/axi_dynclk_0/s00_axi/reg0]
set_property RANGE 64K [get_bd_addr_segs ps_0/Data/SEG_axi_dynclk_0_reg0]
set_property OFFSET 0x40010000 [get_bd_addr_segs ps_0/Data/SEG_axi_dynclk_0_reg0]

assign_bd_address [get_bd_addr_segs hdmi_out_0/v_tc_0/ctrl/Reg]
set_property RANGE 64K [get_bd_addr_segs ps_0/Data/SEG_v_tc_0_Reg]
set_property OFFSET 0x40020000 [get_bd_addr_segs ps_0/Data/SEG_v_tc_0_Reg]

generate_target all [get_files $bd_path/system.bd]
make_wrapper -files [get_files $bd_path/system.bd] -top

add_files -norecurse $bd_path/hdl/system_wrapper.v

add_files -norecurse -fileset constrs_1 zybo_hdmi_out.xdc

set_property verilog_define {TOOL_VIVADO} [current_fileset]

close_project
