#!/bin/bash

SOURCE="/home/cpa/android/kernel"
RAMDISK="/home/cpa/android/ramdisk"
OUT="/home/cpa/android/shamu_out"
export CROSS_COMPILE=~/android/TOOLCHAINS/arm-eabi-4.9/bin/arm-eabi-

# Colorize and add text parameters
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
cya=$(tput setaf 6) # cyan
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # red
bldgrn=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
bldcya=${txtbld}$(tput setaf 6) # cyan
txtrst=$(tput sgr0) # Reset

echo -e "${bldred} Set CCACHE ${txtrst}"
ccache -M50

echo ""

echo -e "${bldred} Remove old zImage and ramdisk ${txtrst}"
rm $OUT/kernel
rm $OUT/boot.img
rm $SOURCE/arch/arm/boot/zImage
rm $OUT/ramdisk.gz

echo ""

echo -e "${bldred} Clean up from prior build ${txtrst}"
cd $SOURCE
make clean
#make mrproper

echo ""
echo -e "${bldred} Use Defconfig Settings ${txtrst}"

cp arch/arm/configs/shamu_defconfig .config

echo ""

echo -e "${bldred} Compiling zImage.. ${txtrst}"
script -q ~/Compile.log -c "
make -j12 "
mv arch/arm/boot/zImage-dtb $OUT/kernel

echo ""

echo -e "${bldred} Compiling ramdisk.. ${txtrst}"
cd $RAMDISK
chmod 750 init* sbin/adbd* sbin/healthd
chmod 644 default* uevent* res/images/charger/*
chmod 755 res res/images res/images/charger
chmod 640 fstab.shamu
find . | cpio -o -H newc | gzip > $OUT/ramdisk.gz

echo ""

echo -e "${bldred} Creating boot.img.. ${txtrst}"
cd $OUT
mkbootimg --kernel kernel --ramdisk ramdisk.gz --cmdline "console=ttyHSL0,115200,n8 androidboot.selinux=permissive androidboot.console=ttyHSL0 androidboot.hardware=shamu msm_rtb.filter=0x37 ehci-hcd.park=3 utags.blkdev=/dev/block/platform/msm_sdcc.1/by-name/utags utags.backup=/dev/block/platform/msm_sdcc.1/by-name/utagsBackup coherent_pool=8M" -o boot.img

echo ""

echo -e "${bldred} Done! ${txtrst}"

echo ""

cd /home/cpa/android

