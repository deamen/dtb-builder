#!/bin/bash
set -e

# Set kernel_ver environment variables
export kernel_ver="v6.13"

export container=$(buildah from --arch ARM64 quay.io/deamen/alpine-base:latest)
buildah config --label maintainer=""github.com/deamen"" $container

# Set kernel_ver environment variables in container
buildah config --env kernel_ver=$kernel_ver $container

buildah run $container apk add git gcc make libc-dev bison flex openssl-dev python3 dtc gcc-arm-none-eabi py3-setuptools swig python3-dev py3-elftools patch
buildah run $container git -c advice.detachedHead=false clone https://github.com/torvalds/linux.git --depth 1 --branch $kernel_ver

buildah config --workingdir "/linux" $container
buildah run $container make -j$(nproc --ignore 1) defconfig
buildah run $container make -j$(nproc --ignore 1) allwinner/sun50i-h618-orangepi-zero3.dtb

copy_script="copy_artifacts.sh"
cat << 'EOF' >> $copy_script
#!/bin/sh
mnt=$(buildah mount $container)
cp $mnt/$1 ./out/$2
buildah umount $container
EOF
chmod a+x $copy_script
buildah unshare ./$copy_script linux/arch/arm64/boot/dts/allwinner/sun50i-h618-orangepi-zero3.dtb dtb_orangepi_zero3.dtb
rm ./$copy_script
buildah rm $container
