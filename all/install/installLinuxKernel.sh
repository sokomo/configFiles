LINUX_KERNEL_PATH=$1


pushd $LINUX_KERNEL_PATH

if [ -d .git ]
then
  touch .scmversion
fi

make prepare


LOCAL_VERSION=$(scripts/setlocalversion)
VERSION_INFO=$(make kernelversion)
KERNEL_RELEASE=$(make kernelrelease)
IMAGE_NAME=$(make image_name)

if [ -z $LOCAL_VERSION ]
then
  LOCAL_VERSION=''
fi

echo "Local kernel version is: $LOCAL_VERSION"
echo "Kernel release is: $VERSION_INFO"
echo "Full kernel version is: $KERNEL_RELEASE"
echo "Image path name is: $IMAGE_NAME"



echo "Install linux kernel"
# make mrproper
# make LANG=$LANG LC_ALL= menuconfig

# pushd $LINUX_KERNEL_PATH

make
make modules_install

# cp -vrf arch/x86/boot/bzImage /boot/vmlinuz-lfs-SYSTEMD
cp -vrf $IMAGE_NAME /boot/vmlinuz$LOCAL_VERSION
mkinitcpio -k $KERNEL_RELEASE -g /boot/initrd${LOCAL_VERSION}.img
cp -vrf System.map /boot/System.map-$KERNEL_RELEASE
cp -vrf .config /boot/config-$KERNEL_RELEASE

install -d /usr/share/doc/linux-$VERSION_INFO
cp -r Documentation/* /usr/share/doc/linux-$VERSION_INFO


echo "Config kernel"

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF


popd

