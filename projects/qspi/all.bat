call vivado -nolog -nojournal -mode batch -source hwdef.tcl
call hsi -nolog -nojournal -mode batch -source fsbl.tcl
call hsi -nolog -nojournal -mode batch -source devicetree.tcl
