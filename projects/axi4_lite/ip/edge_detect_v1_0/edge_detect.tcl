set ip_name "edge_detect"
file delete -force component.xml xgui

# Collect the names of the HDL source files that are used by this IP here.
set file_list [list "hdl/edge_detect.v"]

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

# Generate the XGUI files to accompany this IP core.
ipx::create_xgui_files $core

# Save the IP core.
ipx::save_core $core

# Close the current project.
close_project

file delete -force $ip_name.cache $ip_name.hw $ip_name.ip_user_files $ip_name.xpr
