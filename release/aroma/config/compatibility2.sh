#!/sbin/sh
#

#remove the binaries as they are no longer needed. (kernel handled)
if [ -e /system/bin/mpdecision_bck ] ; then
	busybox mv /system/bin/mpdecision_bck /system/bin/mpdecision
fi
if [ -e /system/bin/thermald ] ; then
	busybox mv /system/bin/thermald /system/bin/thermald_bck
fi
if [ -e /system/lib/hw/power.msm8960.so_bck ] ; then
busybox rm /system/lib/hw/power.msm8960.so
busybox mv /system/lib/hw/power.msm8960.so_bck /system/lib/hw/power.msm8960.so
fi
if [ -e /system/lib/hw/power.flo.so_bck ] ; then
busybox rm /system/lib/hw/power.flo.so
busybox mv /system/lib/hw/power.flo.so_bck /system/lib/hw/power.flo.so
fi

return $?

