rm -fr ramdisk
mkdir -p ramdisk
cd ramdisk
git clone --branch 1_27_0 git://git.busybox.net/busybox 
cd busybox
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- defconfig 
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- install 
mv _install ../_rootfs
cd ..
wget https://matt.ucc.asn.au/dropbear/releases/dropbear-2016.74.tar.bz2
tar xvjf dropbear-2016.74.tar.bz2
cd dropbear-2016.74/
./configure --prefix=$(readlink -f ../_rootfs) --host=arm-linux-gnueabihf --disable-zlib CC=arm-linux-gnueabihf-gcc LDFLAGS="-Wl,--gc-sections" CFLAGS="-ffunction-sections -fdata-sections -Os"
make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" MULTI=1 strip 
ln -s dropbearmulti dropbear
make install
cd ../_rootfs/usr/bin
ln -s ../../sbin/dropbear dbclient
ln -s ../../sbin/dropbear dropbearkey
ln -s ../../sbin/dropbear dropbearconvert
ln -s ../../sbin/dropbear scp
cd ../..
mkdir dev etc etc/dropbear etc/init.d mnt opt proc root sys tmp var var/log var/www 
chmod 700 etc/dropbear
cat > etc/fstab << EOF_CAT
LABEL=/     /           tmpfs   defaults        0 0
none        /dev/pts    devpts  gid=5,mode=620  0 0
none        /proc       proc    defaults        0 0
none        /sys        sysfs   defaults        0 0
none        /tmp        tmpfs   defaults        0 0
EOF_CAT
cat > etc/inittab << EOF_CAT
::sysinit:/etc/init.d/rcS

# /bin/ash
# 
# Start an askfirst shell on the serial ports

ttyPS0::respawn:-/bin/ash

# What to do when restarting the init process

::restart:/sbin/init

# What to do before rebooting

::shutdown:/bin/umount -a -r
EOF_CAT
cat > etc/passwd << EOF_CAT
root:*:0:0:root:/root:/bin/sh
EOF_CAT
cat > etc/init.d/rcS << EOF_CAT
#!/bin/sh
 
echo "Starting rcS..."
 
echo "++ Setting hostname"
hostname "zynq"
 
echo "++ Mounting filesystem"
mount -t proc none /proc
mount -t sysfs none /sys
mount -t tmpfs none /tmp
 
echo "++ Setting up mdev"
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s
 
mkdir -p /dev/pts
mount -t devpts devpts /dev/pts
 
#echo "++ Configuring MAC address"
#ifconfig eth0 192.168.10.10 up
ifconfig eth0 up
ifconfig lo up
 
echo "++ Starting DHCP daemon"
udhcpc -s /etc/dhcp/update.sh
 
echo "++ Starting telnet daemon"
telnetd -l /bin/sh
 
echo "++ Starting http daemon"
httpd -h /var/www
 
echo "++ Starting ftp daemon"
tcpsvd 0:21 ftpd ftpd -w /&
 
echo "++ Starting dropbear (ssh) daemon"
dropbear -B
 
echo "rcS Complete"
EOF_CAT
chmod 755 etc/init.d/rcS
mkdir -p etc/dhcp
cp ../busybox/examples/udhcp/simple.script etc/dhcp/update.sh
mkdir lib
#cp -r /usr/arm-linux-gnueabihf/lib/* lib
cp /usr/arm-linux-gnueabihf/lib/{libc.so.6,libm.so.6,ld-linux-armhf.so.3,libutil.so.1,libcrypt.so.1,libnsl.so.1,libnss_compat.so.2} lib
cat > root/.profile << EOF_CAT
export PATH=/sbin:/usr/sbin:/bin:/usr/bin
EOF_CAT
cd ..
cp /usr/bin/qemu-arm-static _rootfs/usr/bin
mount --bind /dev _rootfs/dev
chroot _rootfs /bin/ash << EOF_CHROOT
cd /etc/dropbear
dropbearkey -t rsa -f dropbear_rsa_host_key
dropbearkey -t dss -f dropbear_dss_host_key
dropbearkey -t ecdsa -f dropbear_ecdsa_host_key
echo root:1234 | chpasswd
EOF_CHROOT
umount _rootfs/dev
rm _rootfs/usr/bin/qemu-arm-static
dd if=/dev/zero of=ramdisk.img bs=1024 count=16384
mke2fs -F ramdisk.img -L "ramdisk" -b 1024 -m 0
tune2fs ramdisk.img -i 0
chmod 777 ramdisk.img
mkdir _ramdisk
mount -o loop ramdisk.img _ramdisk/
cp -R _rootfs/* _ramdisk
umount _ramdisk
rmdir _ramdisk
gzip -9 ramdisk.img
mkimage -A arm -O linux -T ramdisk -C gzip -d ramdisk.img.gz uramdisk.img.gz
