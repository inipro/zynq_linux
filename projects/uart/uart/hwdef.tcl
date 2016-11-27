# vivado -nolog -nojournal -mode batch -source hwdef.tcl

set project_name uart

open_project $project_name/$project_name.xpr

if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
		launch_runs synth_1
				wait_on_run synth_1
}

file delete -force $project_name/$project_name.hwdef

write_hwdef -force -file $project_name/$project_name.hwdef

close_project
