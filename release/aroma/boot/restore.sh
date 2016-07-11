#!/sbin/sh

# Read the settings file
if [ -f "/system/etc/glitch-settings.conf" ];
then

. /system/etc/glitch-settings.conf

if [ "$HOTPLUGDRV" == "0" ] ; then
if [ -e /system/bin/mpdecision_bck ] ; then
busybox mv /system/bin/mpdecision_bck /system/bin/mpdecision
fi
fi

if [ "$HOTPLUGDRV" == "1" ] ; then
if [ -e /system/bin/mpdecision ] ; then
busybox mv /system/bin/mpdecision /system/bin/mpdecision_bck
fi
fi

if [ "$HOTPLUGDRV" == "2" ] ; then
if [ -e /system/bin/mpdecision ] ; then
busybox mv /system/bin/mpdecision /system/bin/mpdecision_bck
fi
fi

if [ "$HOTPLUGDRV" == "3" ] ; then
if [ -e /system/bin/mpdecision ] ; then
busybox mv /system/bin/mpdecision /system/bin/mpdecision_bck
fi
fi

if [ -e /system/bin/thermald ] ; then
busybox mv /system/bin/thermald /system/bin/thermald_bck
fi

l2_opt="l2_opt="$L2_OC;
vdd_uv="vdd_uv="$UV_LEVEL;

null="abc"

if [ "$PERMISSIVE" == "1" ] ; then
echo "cmdline = console=ttyHSL0,115200,n8 androidboot.hardware=flo user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 vmalloc=340M enforcing=0" $l2_opt $vdd_uv $null >> /tmp/cmdline.cfg
else
echo "cmdline = console=ttyHSL0,115200,n8 androidboot.hardware=flo user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 vmalloc=340M enforcing=1" $l2_opt $vdd_uv $null >> /tmp/cmdline.cfg
fi

else

echo "glitch-settings.conf file not found. If you have one, please restore your backup from SDcard or make a complete installation.";

fi
