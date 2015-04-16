#!/sbin/sh

if [ ! -f /system/xbin/busybox ]; then

   cp /tmp/busybox /system/xbin/busybox; 
   chmod 777 /system/xbin/busybox;
fi


if [ ! -d /system/etc/init.d ]; then
   if [ -f /system/etc/init.d ]; then
      mv /system/etc/init.d /system/etc/init.d.bak;
   fi
   mkdir /system/etc/init.d;
fi
