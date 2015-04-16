#!/bin/bash

# Glitch kernel build-script (Aroma Edition)	#
#					  	#
# Options :				  	#
#					  	#
# clean : clean the build directory       	#
# cleank : clean the built kernel packages	#
#################################################

############## Basic configuration ##############

# Device options :
	target_name="N7" #defines the flashable zip device name
	target_variant="-CM" #defines the flashable zip additional name for variants
	target_device="N7-2013" #defines the name of device-related folders (can be the same as $target_name)
	target_defconfig="Glitch_flo_defconfig" #defines the config to use for the build

# Toolchain selection :
# (default path is "kernel_tree_folder/../toolchains")
# -------linux-x86
	#export CROSS_PREFIX="arm-eabi-4.6/bin/arm-eabi-"
	#export CROSS_PREFIX="sabermod-androideabi-4.8.3/bin/arm-linux-androideabi-"
	export CROSS_PREFIX="arm-cortex_a15-linux-gnueabihf-linaro_4.9.3-2015.03/bin/arm-cortex_a15-linux-gnueabihf-"

# -------darwin-x86
	#export CROSS_PREFIX=""

########## End of basic configuration ############

setup ()
{
function mka() {
    case `uname -s` in
        Darwin)
            make -j `sysctl hw.ncpu|cut -d" " -f2` "$@"
            ;;
        *)
            schedtool -B -n 1 -e ionice -n 1 make -j `cat /proc/cpuinfo | grep "^processor" | wc -l` "$@"
            ;;
    esac
};

#   Arch-dependent definitions
    case `uname -s` in
        Darwin)
            KERNEL_DIR="$(dirname "$(greadlink -f "$0")")"
            CROSS_PREFIX="$KERNEL_DIR/../toolchains/$CROSS_PREFIX"
            ;;
        *)
            KERNEL_DIR="$(dirname "$(readlink -f "$0")")"
            CROSS_PREFIX="$KERNEL_DIR/../toolchains/$CROSS_PREFIX"
            ;;
    esac

    BUILD_DIR="../glitch-build/kernel"

    if [ x = "x$NO_CCACHE" ] && ccache -V &>/dev/null ; then
        CCACHE=ccache
        CCACHE_BASEDIR="$KERNEL_DIR"
        CCACHE_COMPRESS=1
        CCACHE_DIR="$KERNEL_DIR/../.ccache"
        export CCACHE_DIR CCACHE_COMPRESS CCACHE_BASEDIR
    else
        CCACHE=""
    fi

}

build ()
{
    export ARCH="arm"
    local target=$target_device
    echo "-----------------------------------------"
    echo "Building for $target_device"
    local target_dir="$BUILD_DIR/$target_device"
    local module
    rm -fr "$target_dir"
    rm -f $KERNEL_DIR/tmp_$target_defconfig
    rm -f $KERNEL_DIR/arch/arm/configs/release_$target_defconfig
    mkdir -p "$target_dir"

. $KERNEL_DIR/../rev

#Variant has to use the same rev number as base
#counter=$((counter + 1))

echo "-----------------------------------------"
echo "Write release number in config (r"$counter")"
releasenumber='CONFIG_LOCALVERSION="-Glitch-N7-CM-r'$counter'"'
cp arch/arm/configs/$target_defconfig tmp_$target_defconfig;
sed "43s/.*/$releasenumber/g" tmp_$target_defconfig > release_$target_defconfig;
mv release_$target_defconfig arch/arm/configs/release_$target_defconfig
rm -f $KERNEL_DIR/tmp_$target_defconfig

    mka -C "$KERNEL_DIR" O="$target_dir" release_$target_defconfig HOSTCC="$CCACHE gcc"
    mka -C "$KERNEL_DIR" O="$target_dir" HOSTCC="$CCACHE gcc" CROSS_COMPILE="$CCACHE $CROSS_PREFIX" zImage modules

[[ -d release ]] || {
	echo "-----------------------------------------"
	echo "must be in kernel root dir"
	exit 1;
}

echo "-----------------------------------------"
echo "copying modules and zImage"

#Aroma
mkdir -p $KERNEL_DIR/release/aroma/system/lib/modules/
#Restore
mkdir -p $KERNEL_DIR/release/restore/system/lib/modules/

cd $target_dir

#Aroma
find -name '*.ko' -exec cp -av {} $KERNEL_DIR/release/aroma/system/lib/modules/ \;
"$CROSS_PREFIX"strip --strip-unneeded $KERNEL_DIR/release/aroma/system/lib/modules/*
#Restore
find -name '*.ko' -exec cp -av {} $KERNEL_DIR/release/restore/system/lib/modules/ \;
"$CROSS_PREFIX"strip --strip-unneeded $KERNEL_DIR/release/restore/system/lib/modules/*

cd $KERNEL_DIR

#Aroma
cp $target_dir/arch/arm/boot/zImage $KERNEL_DIR/release/aroma/boot/glitch.zImage
#Restore
cp $target_dir/arch/arm/boot/zImage $KERNEL_DIR/release/restore/boot/glitch.zImage

#Aroma
cd $KERNEL_DIR
rm -f arch/arm/configs/release_$target_defconfig
echo "-----------------------------------------"
echo "Setting date in Aroma conf ("$(date +%B)" "$(date +%e)" "$(date +%Y)")"
AromaDateReplace='ini_set("rom_date",             "'$(date +%B)' '$(date +%e)' '$(date +%Y)'");'
sed "37s/.*/$AromaDateReplace/g" ./release/aroma/META-INF/com/google/android/aroma-config > ./aroma-config.tmp;
mv ./aroma-config.tmp ./release/aroma/META-INF/com/google/android/aroma-config

echo "-----------------------------------------"
echo "packaging it up"

mkdir -p $KERNEL_DIR/release/$target_device

#Aroma
cd $KERNEL_DIR/release/aroma
REL=Glitch-$target_name-r$counter$target_variant-full.zip

	zip -q -r ${REL} boot config META-INF system pie_patch
	#sha256sum ${REL} > ${REL}.sha256sum
	mv ${REL}* $KERNEL_DIR/release/$target_device/

rm boot/glitch.zImage
rm -fr system/lib/modules/*

#Restore
cd $KERNEL_DIR/release/restore
REL2=Glitch-$target_name-r$counter$target_variant-restore.zip

	zip -q -r ${REL2} boot config META-INF system
	#sha256sum ${REL} > ${REL}.sha256sum
	mv ${REL2}* $KERNEL_DIR/release/$target_device/

rm boot/glitch.zImage
rm -fr system/lib/modules/*

#Variant has to use the same rev number as base
#echo counter=$counter > $KERNEL_DIR/../rev;

echo "-----------------------------------------"
echo ${REL}
echo ${REL2}
}
    
setup

if [ "$1" = clean ] ; then
    rm -fr "$BUILD_DIR"/*
    cd release
    rm `find ./ -name '*.*~'` -rf
    rm `find ./ -name '*~'` -rf
    cd $KERNEL_DIR
    rm -f $KERNEL_DIR/tmp_$target_defconfig
    rm -f arch/arm/configs/release_$target_defconfig
    echo "-----------------------------"
    echo "Previous build folder cleaned"
    echo "-----------------------------"

else

if [ "$1" = cleank ] ; then
    rm -fr "$KERNEL_DIR"/release/$target_device/*
    echo "---------------------"
    echo "Built kernels cleaned"
    echo "---------------------"

else

time {

    build $target_device

}
fi
fi
