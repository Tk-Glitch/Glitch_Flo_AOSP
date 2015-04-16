#!/sbin/sh

mkdir /tmp/ramdisk
cp /tmp/initrd.img /tmp/ramdisk/initrd.gz
cd /tmp/ramdisk/
gunzip -c /tmp/ramdisk/initrd.gz | cpio -i
rm /tmp/ramdisk/initrd.gz
rm /tmp/initrd.img

#remove install_recovery
if [ $(grep -c "#seclabel u:r:install_recovery:s0" /tmp/ramdisk/init.rc) == 0 ]; then
   sed -i "s/seclabel u:r:install_recovery:s0/#seclabel u:r:install_recovery:s0/" /tmp/ramdisk/init.rc
fi

#add init.d support if needed
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
cp /tmp/ramdisk/fstab.flo /tmp/ramdisk/fstab.orig;
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

#Cache partition
if [ $CACHE_F2FS -eq 0 ]; then
sed -i 's/^\/dev\/block\/platform\/msm_sdcc.1\/by-name\/cache.*/\/dev\/block\/platform\/msm_sdcc.1\/by-name\/cache        \/cache          f2fs    noatime,nosuid,nodev,nodiratime,discard,inline_xattr,inline_data,inline_dentry,errors=recover    wait,check/' /tmp/ramdisk/fstab.flo
else
sed -i 's/^\/dev\/block\/platform\/msm_sdcc.1\/by-name\/cache.*/\/dev\/block\/platform\/msm_sdcc.1\/by-name\/cache        \/cache          ext4    noatime,nosuid,nodev,barrier=1,data=ordered,noauto_da_alloc,errors=panic    wait,check/' /tmp/ramdisk/fstab.flo
fi;

#Data partition
if [ $DATA_F2FS -eq 0 ]; then
sed -i 's/^\/dev\/block\/platform\/msm_sdcc.1\/by-name\/userdata.*/\/dev\/block\/platform\/msm_sdcc.1\/by-name\/userdata     \/data           f2fs    noatime,nosuid,nodev,nodiratime,discard,inline_xattr,inline_data,inline_dentry,errors=recover    wait,check,encryptable=\/dev\/block\/platform\/msm_sdcc.1\/by-name\/metadata/' /tmp/ramdisk/fstab.flo
else
sed -i 's/^\/dev\/block\/platform\/msm_sdcc.1\/by-name\/userdata.*/\/dev\/block\/platform\/msm_sdcc.1\/by-name\/userdata     \/data           ext4    noatime,nosuid,nodev,barrier=1,data=ordered,noauto_da_alloc,errors=panic    wait,check,encryptable=\/dev\/block\/platform\/msm_sdcc.1\/by-name\/metadata/' /tmp/ramdisk/fstab.flo
fi;

#System partition
if [ $SYSTEM_F2FS -eq 0 ]; then
sed -i 's/^\/dev\/block\/platform\/msm_sdcc.1\/by-name\/system.*/\/dev\/block\/platform\/msm_sdcc.1\/by-name\/system       \/system         f2fs    ro,noatime,nosuid,nodev,nodiratime,discard,inline_xattr,inline_data,inline_dentry,errors=recover    wait/' /tmp/ramdisk/fstab.flo
else
sed -i 's/^\/dev\/block\/platform\/msm_sdcc.1\/by-name\/system.*/\/dev\/block\/platform\/msm_sdcc.1\/by-name\/system       \/system         ext4    ro,barrier=1                                                                 wait/' /tmp/ramdisk/fstab.flo
fi;

#repack
find . | cpio -o -H newc | gzip > /tmp/initrd.img
