# tclsh bootbin.tcl

set project_name qspi

set uimage [file join [pwd] ../../uImage]
set ramdisk [file join [pwd] ../../uramdisk.img.gz]

set fileId [open $project_name/boot.bif "w"]
puts $fileId "img:{\[bootloader\] $project_name/$project_name.fsbl/executable.elf u-boot.elf \[offset=0x100000\]$uimage \[offset=0x600000\]devicetree.dtb \[offset=0x620000\]$ramdisk}"
close $fileId

file delete -force boot.bin

exec bootgen -image $project_name/boot.bif -w -o i boot.bin >&@stdout
