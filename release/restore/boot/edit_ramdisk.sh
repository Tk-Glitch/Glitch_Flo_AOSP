#!/sbin/sh

mkdir /tmp/ramdisk
cp /tmp/initrd.img /tmp/ramdisk/initrd.gz
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/initrd.gz | cpio -i
rm /tmp/ramdisk/initrd.gz
rm /tmp/initrd.img

#Start glitch script
if [ $(grep -c "import /init.glitch.rc" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "/import \/init\.trace\.rc/aimport /init.glitch.rc" /tmp/ramdisk/init.rc
fi

#enable selinux enforcing
if [ $(grep -c "setenforce 0" /tmp/ramdisk/init.rc) == 0 ] && [ $(grep -c "setenforce 1" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "s/setcon u:r:init:s0/setcon u:r:init:s0\n    setenforce 1/" /tmp/ramdisk/init.rc
else
if [ $(grep -c "setenforce 0" /tmp/ramdisk/init.rc) == 1 ]; then
   sed -i "s/setenforce 0/setenforce 1/" /tmp/ramdisk/init.rc
fi
fi

#remove install_recovery
if [ $(grep -c "#seclabel u:r:install_recovery:s0" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "s/seclabel u:r:install_recovery:s0/#seclabel u:r:install_recovery:s0/" /tmp/ramdisk/init.rc
fi

#add init.d support if needed
if [ !$(grep -qr "init.d" /tmp/ramdisk/*) ]; then
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

#System partition
if [ $SYSTEM_F2FS -eq 0 ]; then
	sed -i "/system.*ext4/d" /tmp/fstab
else
	sed -i "/system.*f2fs/d" /tmp/fstab
fi

#Cache partition
if [ $CACHE_F2FS -eq 0 ]; then
	sed -i "/cache.*ext4/d" /tmp/fstab
else
	sed -i "/cache.*f2fs/d" /tmp/fstab
fi

#Data partition
if [ $DATA_F2FS -eq 0 ]; then
	sed -i "/data.*ext4/d" /tmp/fstab
else
	sed -i "/data.*f2fs/d" /tmp/fstab
fi

mv /tmp/fstab /tmp/ramdisk/fstab.flo;

#copy glitch scripts
cp /tmp/glitch.sh /tmp/ramdisk/sbin/glitch.sh
chmod 755 /tmp/ramdisk/sbin/glitch.sh
cp /tmp/init.glitch.rc /tmp/ramdisk/init.glitch.rc

#repack
find . | cpio -o -H newc | gzip > /tmp/initrd.img
