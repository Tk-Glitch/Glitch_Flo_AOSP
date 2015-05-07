#!/sbin/sh

mkdir /tmp/ramdisk
cp /tmp/initrd.img /tmp/ramdisk/initrd.gz
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/initrd.gz | cpio -i
rm /tmp/ramdisk/initrd.gz
rm /tmp/initrd.img

if [ $(grep -c "setenforce 0" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "s/setcon u:r:init:s0/setcon u:r:init:s0\n    setenforce 0/" /tmp/ramdisk/init.rc
fi

if [ $(grep -c "#seclabel u:r:install_recovery:s0" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "s/seclabel u:r:install_recovery:s0/#seclabel u:r:install_recovery:s0/" /tmp/ramdisk/init.rc
fi

if [ $(grep -c "init.d" /tmp/ramdisk/init.rc) == 0 ]; then
   echo "" >> /tmp/ramdisk/init.rc
   echo "service userinit /system/xbin/busybox run-parts /system/etc/init.d" >> /tmp/ramdisk/init.rc
   echo "    oneshot" >> /tmp/ramdisk/init.rc
   echo "    class late_start" >> /tmp/ramdisk/init.rc
   echo "    user root" >> /tmp/ramdisk/init.rc
   echo "    group root" >> /tmp/ramdisk/init.rc
fi

#remove governor overrides, use kernel default
sed -i '/\/sys\/devices\/system\/cpu\/cpu0\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.flo.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu1\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.flo.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu2\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.flo.rc
sed -i '/\/sys\/devices\/system\/cpu\/cpu3\/cpufreq\/scaling_governor/d' /tmp/ramdisk/init.flo.rc

#backup current fstab
if [ ! -f "/tmp/ramdisk/fstab.orig" ]; then
mv /tmp/ramdisk/fstab.flo /tmp/ramdisk/fstab.orig;
fi;

mv /tmp/fstab /tmp/ramdisk/fstab.flo;

#repack
find . | cpio -o -H newc | gzip > /tmp/initrd.img
