#!/sbin/sh

mkdir /tmp/ramdisk
cp /tmp/initrd.img /tmp/ramdisk/initrd.gz
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/initrd.gz | cpio -i
rm /tmp/ramdisk/initrd.gz
rm /tmp/initrd.img

if [ $(grep -c "mount tmpfs tmpfs /storage mode=0050,uid=0,gid=1028" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "/mkdir \/mnt\/asec/i\ \ \ \ mount tmpfs tmpfs /storage mode=0050,uid=0,gid=1028" /tmp/ramdisk/init.rc
fi

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

#add line for CIFs
tmpfs=$(find /tmp/ramdisk/init.rc -type f | xargs grep -oh "mount tmpfs /storage mode=050,uid=0,gid=1028");
if [ "$tmpfs" != 'mount tmpfs /storage mode=050,uid=0,gid=1028' ]; then
	echo "CIF hack found!";
else
sed '/mkdir /storage 0050 root sdcard_r/a \
>     mount tmpfs /storage mode=0050,uid=0,gid=1028' /tmp/ramdisk/init.flo.rc;
	echo "CIF hack added";
fi

#Check for F2FS and change fstab accordingly in ramdisk
mount /cache 2> /dev/null
mount /data 2> /dev/null
mount /system 2> /dev/null

mount | grep -q 'cache type f2fs'
CACHE_F2FS=$?
mount | grep -q 'data type f2fs'
DATA_F2FS=$?
mount | grep -q 'system type f2fs'
SYSTEM_F2FS=$?

if [ $CACHE_F2FS -eq 0 ] || [ $DATA_F2FS -eq 0 ] || [ $SYSTEM_F2FS -eq 0 ]; then

if [ $CACHE_F2FS -eq 0 ]; then
	sed -i 's,#CACHE_ISF2FS,,' /tmp/fstab.tmp;
else
	sed -i 's,#CACHE_ISEXT4,,' /tmp/fstab.tmp;
fi;
if [ $DATA_F2FS -eq 0 ]; then
	sed -i 's,#DATA_ISF2FS,,' /tmp/fstab.tmp;
else
	sed -i 's,#DATA_ISEXT4,,' /tmp/fstab.tmp;
fi;
if [ $SYSTEM_F2FS -eq 0 ]; then
	sed -i 's,#SYS_ISF2FS,,' /tmp/fstab.tmp;
else
	sed -i 's,#SYS_ISEXT4,,' /tmp/fstab.tmp;
fi;

if [ ! -f "/tmp/ramdisk/fstab.orig" ]; then
mv /tmp/ramdisk/fstab.flo /tmp/ramdisk/fstab.orig;
fi;

mv /tmp/fstab.tmp /tmp/ramdisk/fstab.flo;

else

if [ -f "/tmp/ramdisk/fstab.orig" ]; then
mv /tmp/ramdisk/fstab.orig /tmp/ramdisk/fstab.flo;
fi;

fi;

if [ ! -f "/tmp/ramdisk/sepolicy.orig" ]; then
mv /tmp/ramdisk/sepolicy /tmp/ramdisk/sepolicy.orig;
fi;

mv /tmp/sepolicy.tmp /tmp/ramdisk/sepolicy;

#repack
find . | cpio -o -H newc | gzip > /tmp/initrd.img
