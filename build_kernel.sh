#!/bin/bash

rm -rf output
echo "Removing old boot.img..."
rm -f boot.img



export ARCH=arm
export CROSS_COMPILE=~/Kernel/Toolchains/arm-cortex_a15-linux-gnueabihf-linaro_4.9-master/bin/arm-cortex_a15-linux-gnueabihf-
mkdir output

make -C $(pwd) O=output CivZ2_sec_defconfig VARIANT_DEFCONFIG=msm8974_sec_hlte_eur_defconfig SELINUX_DEFCONFIG=selinux_defconfig
make -C $(pwd) O=output

./scripts/mkqcdtbootimg/mkqcdtbootimg --kernel ./output/arch/arm/boot/zImage \
		--ramdisk ramdisk.cpio.gz \
		--dt_dir ./output/arch/arm/boot/ \
		--cmdline "quiet console=null androidboot.hardware=qcom user_debug=23 msm_rtb.filter=0x37 ehci-hcd.park=3" \
		--base 0x00000000 \
		--pagesize 2048 \
		--ramdisk_offset 0x02000000 \
		--tags_offset 0x01E00000 \
		--output boot.img
echo -n "SEANDROIDENFORCE" >> boot.img


