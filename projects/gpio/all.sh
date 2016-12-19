vivado -nolog -nojournal -mode batch -source hwdef.tcl
hsi -nolog -nojournal -mode batch -source fsbl.tcl
tclsh bootbin.tcl

hsi -nolog -nojournal -mode batch -source devicetree.tcl
