set ip_name "axis_ram_writer"
file delete -force component.xml xgui

# Collect the names of the HDL source files that are used by this IP here.
set file_list [list "hdl/axis_ram_writer.v"]

# Create a new Vivado project for this IP and add the source files.
create_project $ip_name . -force
set proj_dir [get_property directory [current_project]]
set proj_name [get_projects $ip_name]
set proj_fileset [get_filesets sources_1]
add_files -norecurse -scan_for_includes -fileset $proj_fileset $file_list
set_property "top" "$ip_name" $proj_fileset
ipx::package_project -root_dir .

# Set the IP core information properties.
set core [ipx::current_core]
set_property vendor {hokim} $core
set_property library {ip} $core
set_property version {1.0} $core
set_property vendor_display_name {Hyunok Kim} $core
set_property company_url {https://github.com/hokim72} $core
set_property supported_families {{zynq} {Production}} $core
set_property name $ip_name $core
set_property display_name $ip_name $core
set_property description $ip_name $core


set parameter [ipx::get_user_parameters AXI_DATA_WIDTH -of_objects $core]
set_property DISPLAY_NAME {AXI DATA WIDTH} $parameter
set_property DESCRIPTION {Width of the AXI data bus.} $parameter

set parameter [ipgui::get_guiparamspec -name AXI_DATA_WIDTH -component $core]
set_property DISPLAY_NAME {AXI DATA WIDTH} $parameter
set_property TOOLTIP {Width of the AXI data bus.} $parameter

set parameter [ipx::get_user_parameters AXI_ADDR_WIDTH -of_objects $core]
set_property DISPLAY_NAME {AXI ADDR WIDTH} $parameter
set_property DESCRIPTION {Width of the AXI address bus.} $parameter

set parameter [ipgui::get_guiparamspec -name AXI_ADDR_WIDTH -component $core]
set_property DISPLAY_NAME {AXI ADDR WIDTH} $parameter
set_property TOOLTIP {Width of the AXI address bus.} $parameter

#set parameter [ipx::get_user_parameters AXI_ID_WIDTH -of_objects $core]
#set_property DISPLAY_NAME {AXI ID WIDTH} $parameter
#set_property DESCRIPTION {Width of the AXI ID bus.} $parameter

#set parameter [ipgui::get_guiparamspec -name AXI_ID_WIDTH -component $core]
#set_property DISPLAY_NAME {AXI ID WIDTH} $parameter
#set_property TOOLTIP {Width of the AXI ID bus.} $parameter

set parameter [ipx::get_user_parameters AXIS_TDATA_WIDTH -of_objects $core]
set_property DISPLAY_NAME {AXIS TDATA WIDTH} $parameter
set_property DESCRIPTION {Width of the S_AXIS data bus.} $parameter

set parameter [ipgui::get_guiparamspec -name AXIS_TDATA_WIDTH -component $core]
set_property DISPLAY_NAME {AXIS TDATA WIDTH} $parameter
set_property TOOLTIP {Width of the S_AXIS data bus.} $parameter

set parameter [ipx::get_user_parameters ADDR_WIDTH -of_objects $core]
set_property DISPLAY_NAME {ADDR WIDTH} $parameter
set_property DESCRIPTION {Width of the address.} $parameter

set parameter [ipgui::get_guiparamspec -name ADDR_WIDTH -component $core]
set_property DISPLAY_NAME {ADDR WIDTH} $parameter
set_property TOOLTIP {Width of the address.} $parameter

set address [ipx::get_address_spaces m_axi -of_objects $core]
set_property NAME M_AXI $address

set bus [ipx::get_bus_interfaces -of_objects $core m_axi]
set_property NAME M_AXI $bus
set_property INTERFACE_MODE master $bus
set_property MASTER_ADDRESS_SPACE_REF M_AXI $bus

set bus [ipx::get_bus_interfaces -of_objects $core s_axis]
set_property NAME S_AXIS $bus
set_property INTERFACE_MODE slave $bus

set bus [ipx::get_bus_interfaces aclk]
set parameter [ipx::get_bus_parameters -of_objects $bus ASSOCIATED_BUSIF]
set_property VALUE M_AXI:S_AXIS $parameter

# Generate the XGUI files to accompany this IP core.
ipx::create_xgui_files $core

# Save the IP core.
ipx::save_core $core

# Close the current project.
close_project

file delete -force $ip_name.cache $ip_name.hw $ip_name.ip_user_files $ip_name.xpr
