#!/sbin/sh
#

#remove the binaries as they are no longer needed. (kernel handled)
if [ -e /system/bin/mpdecision ] ; then
	busybox mv /system/bin/mpdecision /system/bin/mpdecision_bck
fi
if [ -e /system/bin/thermald ] ; then
	busybox mv /system/bin/thermald /system/bin/thermald_bck
fi
if [ ! -e /system/lib/hw/power.msm8960.so_bck ] ; then
busybox mv /system/lib/hw/power.msm8960.so /system/lib/hw/power.msm8960.so_bck
fi
if [ ! -e /system/lib/hw/power.flo.so_bck ] ; then
busybox mv /system/lib/hw/power.flo.so /system/lib/hw/power.flo.so_bck
fi

return $?

