# dtb-builder
Build mainline dtb files with Buildah and Qemu User Emulator

# How to build dtb for Orange Pi Zero3
```bash
./orangepi_zero3/build_dtb_orangepi_zero3.sh

# The vendor u-boot uses the dtb filename as sun50i-h616-orangepi-zero3.dtb
cp out/dtb/orangepi-zero3.dtb /boot/dtb/allwinner/sun50i-h616-orangepi-zero3.dtb
```
