# tclsh bootbin.tcl

set project_name qspi

set uimage [file join [pwd] ../../uImage]
set ramdisk [file join [pwd] ../../uramdisk.img.gz]

set fileId [open $project_name/boot.bif "w"]
puts $fileId "img:{\[bootloader\] $project_name/$project_name.fsbl/executable.elf $project_name/$project_name.runs/impl_1/system_wrapper.bit u-boot.elf \[offset=0x300000\]$uimage \[offset=0x800000\]devicetree.dtb \[offset=0x820000\]$ramdisk}"
close $fileId

file delete -force boot.bin

exec bootgen -image $project_name/boot.bif -w -o i boot.bin >&@stdout
