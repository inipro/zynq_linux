mkdir -p dl

UBUNTU_URL=http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release
UBUNTU=ubuntu-base-16.04.3-base-armhf.tar.gz

if [ ! -f dl/$UBUNTU ]; then
	wget $UBUNTU_URL/$UBUNTU -O dl/$UBUNTU
fi

ROOT_DIR=root
mkdir -p $ROOT_DIR
cd $ROOT_DIR
tar xvf ../dl/$UBUNTU
rm -fr boot
cd ..
cat > $ROOT_DIR/etc/fstab << EOF_CAT
# /etc/fstab: static file system information.
# <file system> <mount point>   <type>  <options>              <dump>  <pass>
/dev/mmcblk0p1  /boot           vfat    errors=remount-ro      0       0
/dev/mmcblk0p2  /               ext4    errors=remount-ro      0       1
EOF_CAT

cp /etc/resolv.conf         $ROOT_DIR/etc/
cp /usr/bin/qemu-arm-static $ROOT_DIR/usr/bin/
chroot $ROOT_DIR << EOF_CHROOT
apt update
apt -y upgrade
DEBIAN_FRONTEND=noninteractive apt -y install lsb-release bc vim nano sudo openssh-server udev usbutils u-boot-tools device-tree-compiler kmod net-tools resolvconf wpasupplicant parted rfkill lshw wireless-tools gcc g++ cmake python git i2c-tools iputils-ping lxterminal leafpad linux-firmware tzdata locales ethtool
echo "Asia/Seoul" > /etc/timezone
ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime
locale-gen en_US.UTF-8 ko_KR.UTF-8
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
apt clean
EOF_CHROOT

#rm $ROOT_DIR/etc/resolv.conf
rm $ROOT_DIR/usr/bin/qemu-arm-static

mkdir -pv $ROOT_DIR/etc/systemd/system/serial-getty\@ttyPS0.service.d
cat > $ROOT_DIR/etc/systemd/system/serial-getty\@ttyPS0.service.d/autologin.conf << EOF_CAT
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root -s %I 115200,38400,9600 linux
EOF_CAT

mkdir -pv $ROOT_DIR/etc/systemd/system/serial-getty\@ttyUL0.service.d
cat > $ROOT_DIR/etc/systemd/system/serial-getty\@ttyUL0.service.d/autologin.conf << EOF_CAT
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root -s %I 115200,38400,9600 linux
EOF_CAT

ARCH=armhf
SIZE=3500
mkdir -p img
TARGET=img/ubuntu-core_${ARCH}_16.04
dd if=/dev/zero of=$TARGET.img bs=1M count=$SIZE
DEVICE=$(losetup -f)
losetup $DEVICE $TARGET.img
parted -s $DEVICE mklabel msdos
parted -s $DEVICE mkpart primary fat16 4MB 128MB
parted -s $DEVICE mkpart primary ext4 128MB 100%
BOOT_DEV=${DEVICE}p1
ROOT_DEV=${DEVICE}p2
mkfs.vfat -v $BOOT_DEV
mkfs.ext4 -F -j $ROOT_DEV

_ROOT_DIR=_root
mkdir -p $_ROOT_DIR
mount $ROOT_DEV $_ROOT_DIR
cp -a $ROOT_DIR/* $_ROOT_DIR
umount -l $_ROOT_DIR
rmdir $_ROOT_DIR
cd $ROOT_DIR
tar cvzf ../$TARGET.tgz *
cd ..
rm -fr $ROOT_DIR
losetup -d $DEVICE
