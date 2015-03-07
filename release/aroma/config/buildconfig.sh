#!/sbin/sh

#Build config file
CONFIGFILE="/tmp/glitch-settings.conf"

#Wake Gestures
WG=`grep "selected.0" /tmp/aroma/wg.prop | cut -d '=' -f2`
echo -e "\n\n##### Wake Gestures Settings #####\n# 0 to disable wake gestures" >> $CONFIGFILE
echo -e "# 1 to enable wake gestures\n" >> $CONFIGFILE
if [ "$WG" = 1 ]; then
  echo "WG=1" >> $CONFIGFILE;
else
  echo "WG=0" >> $CONFIGFILE;
fi

if [ ! -e /tmp/aroma/gest.prop ]; then
  touch /tmp/aroma/gest.prop;
fi

#S2W
SR=`grep "item.1.1" /tmp/aroma/gest.prop | cut -d '=' -f2`
SL=`grep "item.1.2" /tmp/aroma/gest.prop | cut -d '=' -f2`
SU=`grep "item.1.3" /tmp/aroma/gest.prop | cut -d '=' -f2`
SD=`grep "item.1.4" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo -e "\n\n##### Sweep2wake Settings #####\n# 0 to disable sweep2wake" >> $CONFIGFILE
echo -e "# 1 to enable sweep right" >> $CONFIGFILE
echo -e "# 2 to enable sweep left" >> $CONFIGFILE
echo -e "# 4 to enable sweep up" >> $CONFIGFILE
echo -e "# 8 to enable sweep down\n" >> $CONFIGFILE
echo -e "# For combinations, add values together (e.g. all gestures enabled = 15)\n" >> $CONFIGFILE
if [ "$SL" = 1 ]; then
  SL=2
fi
if [ "$SU" = 1 ]; then
  SU=4
fi
if [ "$SD" = 1 ]; then
  SD=8
fi  

S2W=$(( SL + SR + SU + SD ))
echo S2W=$S2W >> $CONFIGFILE;

#DT2W
DT2W=`grep "item.1.5" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo -e "\n\n##### DoubleTap2Wake Settings #####\n# 0 to disable DoubleTap2Wake" >> $CONFIGFILE
echo -e "# 1 to enable DoubleTap2Wake\n" >> $CONFIGFILE
if [ "$DT2W" = 1 ]; then
  echo "DT2W=1" >> $CONFIGFILE;
else
  echo "DT2W=0" >> $CONFIGFILE;
fi

#Shortsweep
SHORTSWEEP=`grep "item.2.1" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo -e "\n\n##### Shortsweep Settings #####\n# 0 to disable Shortsweep" >> $CONFIGFILE
echo -e "# 1 to enable Shortsweep\n" >> $CONFIGFILE
if [ "$SHORTSWEEP" = 1 ]; then
  echo "SHORTSWEEP=1" >> $CONFIGFILE;
else
  echo "SHORTSWEEP=0" >> $CONFIGFILE;
fi

#S2W Power key toggle
PWR_KEY=`grep "item.2.2" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo -e "\n\n##### Power Key Toggles S2W/DT2W #####\n# 0 to disable" >> $CONFIGFILE
echo -e "# 1 to enable\n" >> $CONFIGFILE
if [ "$PWR_KEY" = 1 ]; then
  echo "PWR_KEY=1" >> $CONFIGFILE;
else
  echo "PWR_KEY=0" >> $CONFIGFILE;
fi

#S2W Magnetic cover toggle
LID_SUS=`grep "item.2.3" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo -e "\n\n##### Magnetic Cover Toggles S2W/DT2W #####\n# 0 to disable" >> $CONFIGFILE
echo -e "# 1 to enable\n" >> $CONFIGFILE
if [ "$LID_SUS" = 1 ]; then
  echo "LID_SUS=1" >> $CONFIGFILE;
else
  echo "LID_SUS=0" >> $CONFIGFILE;
fi

#S2W/DT2W Timeout
if [ ! -e /tmp/aroma/timeout.prop ]; then
  touch /tmp/aroma/timeout.prop;
fi

TIMEOUT=`cat /tmp/aroma/timeout.prop | cut -d '=' -f2`
echo -e "\n\n##### S2W/DT2W Timeout #####\n# 0 = disabled" >> $CONFIGFILE
echo -e "# Otherwise, specify number of minutes (default is 60)\n" >> $CONFIGFILE
if [ "$TIMEOUT" = 1 ]; then
  echo "TIMEOUT=15" >> $CONFIGFILE;
elif [ "$TIMEOUT" = 2 ]; then
  echo "TIMEOUT=30" >> $CONFIGFILE;
elif [ "$TIMEOUT" = 3 ]; then
  echo "TIMEOUT=60" >> $CONFIGFILE;
elif [ "$TIMEOUT" = 4 ]; then
  echo "TIMEOUT=90" >> $CONFIGFILE;
elif [ "$TIMEOUT" = 5 ]; then
  echo "TIMEOUT=120" >> $CONFIGFILE;
else
  echo "TIMEOUT=0" >> $CONFIGFILE;
fi

#S2S
S2S=`grep "item.1.1" /tmp/aroma/s2s.prop | cut -d '=' -f2`
echo -e "\n\n##### Sweep2Sleep Settings #####\n# 0 to disable Sweep2Sleepe" >> $CONFIGFILE
echo -e "# 1 to enable Sweep2Sleep\n" >> $CONFIGFILE
if [ "$S2S" = 1 ]; then
  echo "S2S=1" >> $CONFIGFILE;
else
  echo "S2S=0" >> $CONFIGFILE;
fi

#S2S Options
PORTRAIT=`grep "item.2.1" /tmp/aroma/s2s.prop | cut -d '=' -f2`
LANDSCAPE=`grep "item.2.2" /tmp/aroma/s2s.prop | cut -d '=' -f2`
echo -e "\n\n##### Sweep2sleep Orientation Settings #####\n# 0 to enable portrait and landscape" >> $CONFIGFILE
echo -e "# 1 to disable sweep2sleep landscape mode\n" >> $CONFIGFILE
echo -e "# 2 to disable sweep2sleep in portrait mode\n" >> $CONFIGFILE
if [ "$PORTRAIT" = 1 ]; then
  echo "ORIENTATION=1" >> $CONFIGFILE;
elif [ "$LANDSCAPE" = 1 ]; then
  echo "ORIENTATION=2" >> $CONFIGFILE;
else
  echo "ORIENTATION=0" >> $CONFIGFILE;
fi

#Fast Charge
FAST_CHARGE=`grep "item.0.1" /tmp/aroma/misc.prop | cut -d '=' -f2`
echo -e "\n\n##### Force fast-charge Settings #####\n# 0 to disable fast-charge" >> $CONFIGFILE
echo -e "# 1 to enable fast-charge\n" >> $CONFIGFILE
if [ "$FAST_CHARGE" = 1 ]; then
  echo "FAST_CHARGE=1" >> $CONFIGFILE;
else
  echo "FAST_CHARGE=0" >> $CONFIGFILE;
fi

#Magnetic on/off
LID=`grep "item.0.2" /tmp/aroma/misc.prop | cut -d '=' -f2`
echo -e "\n\n##### Magnetic on/off Settings #####\n# 0 to disable Magnetic on/off" >> $CONFIGFILE
echo -e "# 1 to enable Magnetic on/off\n" >> $CONFIGFILE
if [ "$LID" = 1 ]; then
  echo "LID=0" >> $CONFIGFILE;
else
  echo "LID=1" >> $CONFIGFILE;
fi

#USB Host mode charging
OTGCM=`grep "item.0.3" /tmp/aroma/misc.prop | cut -d '=' -f2`
echo -e "\n\n##### USB OTG+Charge Settings ######\n# 1 to enable USB host mode charging\n# 0 to disable USB host mode charging\n" >> $CONFIGFILE
if [ "$OTGCM" = 1 ]; then
  echo "OTGCM=1" >> $CONFIGFILE;
else
  echo "OTGCM=0" >> $CONFIGFILE;
fi

#Backlight dimmer
BLD=`grep "item.0.4" /tmp/aroma/misc.prop | cut -d '=' -f2`
echo -e "\n\n##### Backlight Dimmer Settings ######\n# Adjust screen brightness. A value of 4 is default, higher values decrease brightness.\n" >> $CONFIGFILE
if [ $BLD = 1 ]; then
  echo "BLD=4" >> $CONFIGFILE;
else
  echo "BLD=0" >> $CONFIGFILE;
fi

#MC Power Savings
MC_POWERSAVE=`grep "item.0.6" /tmp/aroma/misc.prop | cut -d '=' -f2`
echo -e "\n\n##### MC Power savings Settings #####\n# 0 to disable MC power savings" >> $CONFIGFILE
echo -e "# 1 to enable maximum MC power savings\n" >> $CONFIGFILE
if [ "$MC_POWERSAVE" = 1 ]; then
  echo "MC_POWERSAVE=1" >> $CONFIGFILE;
else
  echo "MC_POWERSAVE=0" >> $CONFIGFILE;
fi

#Permissive Selinux
PERMISSIVE=`grep "item.0.8" /tmp/aroma/misc.prop | cut -d '=' -f2`
echo -e "\n\n##### Enforce Selinux #####\n# 0 for default" >> $CONFIGFILE
echo -e "# 1 to enable permissive Selinux\n" >> $CONFIGFILE
if [ "$PERMISSIVE" = 1 ]; then
  echo "PERMISSIVE=1" >> $CONFIGFILE;
else
  echo "PERMISSIVE=0" >> $CONFIGFILE;
fi

#THERMAL
THERM=`grep selected.1 /tmp/aroma/nrg.prop | cut -d '=' -f2`
echo -e "\n\n##### Thermal Settings #####\n# 0 for default thermal throttling" >> $CONFIGFILE
echo -e "# 1 to run cool\n# 2 to run hot\n" >> $CONFIGFILE
if [ "$THERM" = 1 ]; then
  echo "THERM=1" >> $CONFIGFILE;
elif [ "$THERM" = 3 ]; then
  echo "THERM=2" >> $CONFIGFILE;
else
  echo "THERM=0" >> $CONFIGFILE;
fi

#Battery life extender
BLE=`grep selected.2 /tmp/aroma/nrg.prop | cut -d '=' -f2`
echo -e "\n\n##### Battery life eXtender #####\n# 1 4.3V (stock - 100%)" >> $CONFIGFILE
echo -e "# 2 4.2V (balanced - 93%)\n# 3 4.1V (conservative - 83%)\n# 4 4.0V (very conservative - 73%)\n" >> $CONFIGFILE
if [ "$BLE" = 2 ]; then
  echo "BLE=2" >> $CONFIGFILE;
elif [ "$BLE" = 3 ]; then
  echo "BLE=3" >> $CONFIGFILE;
elif [ "$BLE" = 4 ]; then
  echo "BLE=4" >> $CONFIGFILE;
else
  echo "BLE=1" >> $CONFIGFILE;
fi

#GPU UV
GPU_UV=`grep selected.4 /tmp/aroma/nrg.prop | cut -d '=' -f2`
echo -e "\n\n##### GPU Undervolting #####\n# 1 Stock\n# 2 -25mV" >> $CONFIGFILE
echo -e "# 3 -50mV\n# 4 -75mV\n# 5 -100mV\n# 6 -125mV\n# 7 -150mV\n" >> $CONFIGFILE
if [ "$GPU_UV" = 2 ]; then
  echo "GPU_UV=2" >> $CONFIGFILE;
elif [ "$GPU_UV" = 3 ]; then
  echo "GPU_UV=3" >> $CONFIGFILE;
elif [ "$GPU_UV" = 4 ]; then
  echo "GPU_UV=4" >> $CONFIGFILE;
elif [ "$GPU_UV" = 5 ]; then
  echo "GPU_UV=5" >> $CONFIGFILE;
elif [ "$GPU_UV" = 6 ]; then
  echo "GPU_UV=6" >> $CONFIGFILE;
elif [ "$GPU_UV" = 7 ]; then
  echo "GPU_UV=7" >> $CONFIGFILE;
else
  echo "GPU_UV=1" >> $CONFIGFILE;
fi

#GPU Clock
GPU_OC=`grep selected.1 /tmp/aroma/gpu.prop | cut -d '=' -f2`
echo -e "\n\n##### Max GPU Clock #####\n# 1 320 MHz" >> $CONFIGFILE
echo -e "# 2 400 MHz\n# 3 450 MHz\n# 4 504 MHz\n# 5 545 MHz\n# 6 600 MHz\n# 7 627 MHz\n" >> $CONFIGFILE
if [ "$GPU_OC" = 1 ]; then
  echo "GPU_OC=1" >> $CONFIGFILE;
elif [ "$GPU_OC" = 3 ]; then
  echo "GPU_OC=3" >> $CONFIGFILE;
elif [ "$GPU_OC" = 4 ]; then
  echo "GPU_OC=4" >> $CONFIGFILE;
elif [ "$GPU_OC" = 5 ]; then
  echo "GPU_OC=5" >> $CONFIGFILE;
elif [ "$GPU_OC" = 6 ]; then
  echo "GPU_OC=6" >> $CONFIGFILE;
elif [ "$GPU_OC" = 7 ]; then
  echo "GPU_OC=7" >> $CONFIGFILE;
else
  echo "GPU_OC=2" >> $CONFIGFILE;
fi

#GPU Governor
#GPU_GOV=`grep selected.2 /tmp/aroma/gpu.prop | cut -d '=' -f2`
#echo -e "\n\n##### GPU Governor #####\n# 1 Ondemand (default)" >> $CONFIGFILE
#echo -e "# 2 Interactive\n# 3 Performance\n" >> $CONFIGFILE
#if [ "$GPU_GOV" = 2 ]; then
#  echo "GPU_GOV=2" >> $CONFIGFILE;
#else
#  echo "GPU_GOV=1" >> $CONFIGFILE;
#fi

#I/O scheduler
IOSCHED=`grep selected.1 /tmp/aroma/disk.prop | cut -d '=' -f2`
echo -e "\n\n##### I/O scheduler #####\n# 1 cfq (stock)\n# 2 row" >> $CONFIGFILE
echo -e "# 3 deadline\n# 4 fiops\n# 5 sio# 6 noop\n" >> $CONFIGFILE
if [ "$IOSCHED" = 2 ]; then
  echo "IOSCHED=2" >> $CONFIGFILE;
elif [ "$IOSCHED" = 3 ]; then
  echo "IOSCHED=3" >> $CONFIGFILE;
elif [ "$IOSCHED" = 4 ]; then
  echo "IOSCHED=4" >> $CONFIGFILE;
elif [ "$IOSCHED" = 5 ]; then
  echo "IOSCHED=5" >> $CONFIGFILE;
elif [ "$IOSCHED" = 6 ]; then
  echo "IOSCHED=6" >> $CONFIGFILE;
else
  echo "IOSCHED=1" >> $CONFIGFILE;
fi

#read-ahead
READAHEAD=`grep selected.2 /tmp/aroma/disk.prop | cut -d '=' -f2`
echo -e "\n\n##### Read-ahead buffer size (KB) #####\n# 1 128 (stock)\n# 2 256" >> $CONFIGFILE
echo -e "# 3 512\n# 4 1024\n# 5 2048\n" >> $CONFIGFILE
if [ "$READAHEAD" = 2 ]; then
  echo "READAHEAD=2" >> $CONFIGFILE;
elif [ "$READAHEAD" = 3 ]; then
  echo "READAHEAD=3" >> $CONFIGFILE;
elif [ "$READAHEAD" = 4 ]; then
  echo "READAHEAD=4" >> $CONFIGFILE;
elif [ "$READAHEAD" = 5 ]; then
  echo "READAHEAD=5" >> $CONFIGFILE;
elif [ "$READAHEAD" = 6 ]; then
  echo "READAHEAD=6" >> $CONFIGFILE;
else
  echo "READAHEAD=1" >> $CONFIGFILE;
fi

#CPU governor
CPU_GOV=`grep selected.4 /tmp/aroma/cpu.prop | cut -d '=' -f2`
echo -e "\n\n##### CPU governor #####\n# 1 ondemand (stock)" >> $CONFIGFILE
echo -e "# 2 interactive\n# 3 intellidemand\n# 4 smartmax" >> $CONFIGFILE
echo -e "# 5 smartmax_eps\n# 6 intelliactive\n# 7 conservative\n" >> $CONFIGFILE
if [ "$CPU_GOV" = 2 ]; then
  echo "CPU_GOV=2" >> $CONFIGFILE;
elif [ "$CPU_GOV" = 3 ]; then
  echo "CPU_GOV=3" >> $CONFIGFILE;
elif [ "$CPU_GOV" = 4 ]; then
  echo "CPU_GOV=4" >> $CONFIGFILE;
elif [ "$CPU_GOV" = 5 ]; then
  echo "CPU_GOV=5" >> $CONFIGFILE;
elif [ "$CPU_GOV" = 6 ]; then
  echo "CPU_GOV=6" >> $CONFIGFILE;
elif [ "$CPU_GOV" = 7 ]; then
  echo "CPU_GOV=7" >> $CONFIGFILE;
else
  echo "CPU_GOV=1" >> $CONFIGFILE;
fi

#Max screen off frequency
if [ -f "/tmp/aroma/maxscroff.prop" ];
then
SCROFF=`cat /tmp/aroma/maxscroff.prop | cut -d '=' -f2`
echo -e "\n\n##### Max screen off frequency ######\n# 0 disabled\n# 1 594MHz\n# 2 702MHz" >> $CONFIGFILE
echo -e "# 3 810MHz\n# 4 1026MHz\n# 5 1242MHz\n" >> $CONFIGFILE
if [ "$SCROFF" = 1 ]; then
  echo "SCROFF=1" >> $CONFIGFILE;
elif [ "$SCROFF" = 2 ]; then
  echo "SCROFF=2" >> $CONFIGFILE;
elif [ "$SCROFF" = 3 ]; then
  echo "SCROFF=3" >> $CONFIGFILE;
elif [ "$SCROFF" = 4 ]; then
  echo "SCROFF=4" >> $CONFIGFILE;
elif [ "$SCROFF" = 5 ]; then
  echo "SCROFF=5" >> $CONFIGFILE;
else
  echo "SCROFF=0" >> $CONFIGFILE;
fi
else
echo "selected.0=99" > /tmp/aroma/maxscroff.prop
echo -e "\n\n##### Max screen off frequency ######\n# 0 disabled\n# 1 594MHz\n# 2 702MHz" >> $CONFIGFILE
echo -e "# 3 810MHz\n# 4 1026MHz\n# 5 1242MHz\n" >> $CONFIGFILE
echo "SCROFF=0" >> $CONFIGFILE;
fi

echo -e "\n\n####################################################################" >> $CONFIGFILE
echo -e "# Anything past this is a backup of your initialization settings   #" >> $CONFIGFILE
echo -e "# for Aroma Installer to restore them if asked.                    #" >> $CONFIGFILE
echo -e "# Edit these lines only if you're planning to reinstall the kernel #" >> $CONFIGFILE
echo -e "# and restore settings, as they won't be applied outside of Aroma. #" >> $CONFIGFILE
echo -e "####################################################################\n\n" >> $CONFIGFILE

if [ ! -e /tmp/aroma-data/freq1.prop ]; then
	cp /tmp/aroma-data/freq0.prop /tmp/aroma-data/freq1.prop;
	cp /tmp/aroma-data/freq0.prop /tmp/aroma-data/freq2.prop;
	cp /tmp/aroma-data/freq0.prop /tmp/aroma-data/freq3.prop;
fi

#MAXFREQ
if [ -f "/tmp/aroma/freq0.prop" ];
then
MAXF_CPU0=`cat /tmp/aroma/freq0.prop | cut -d '=' -f2`
echo -e "\n\n##### Maximum CPU0 frequency (MHz) #####\n# 1512, 1620, 1728, 1836, 1890, 1944, 1998\n# 2052, 2106, 2160, 2214, 2268, 2322\n" >> $CONFIGFILE
if [ "$MAXF_CPU0" = 2 ]; then
  echo "MAXF_CPU0=1620" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 3 ]; then
  echo "MAXF_CPU0=1728" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 4 ]; then
  echo "MAXF_CPU0=1836" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 5 ]; then
  echo "MAXF_CPU0=1890" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 6 ]; then
  echo "MAXF_CPU0=1944" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 7 ]; then
  echo "MAXF_CPU0=1998" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 8 ]; then
  echo "MAXF_CPU0=2052" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 9 ]; then
  echo "MAXF_CPU0=2106" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 10 ]; then
  echo "MAXF_CPU0=2160" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 11 ]; then
  echo "MAXF_CPU0=2214" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 12 ]; then
  echo "MAXF_CPU0=2268" >> $CONFIGFILE;
elif [ "$MAXF_CPU0" = 13 ]; then
  echo "MAXF_CPU0=2322" >> $CONFIGFILE;
else
  echo "MAXF_CPU0=1512" >> $CONFIGFILE;
fi
else
echo "selected.0=99" > /tmp/aroma/freq0.prop
echo -e "\n\n##### Maximum CPU0 frequency (MHz) #####\n# 1512, 1620, 1728, 1836, 1890, 1944, 1998\n# 2052, 2106, 2160, 2214, 2268, 2322\n" >> $CONFIGFILE
echo "MAXF_CPU0=1512" >> $CONFIGFILE;
fi

if [ -f "/tmp/aroma/freq1.prop" ];
then
MAXF_CPU1=`cat /tmp/aroma/freq1.prop | cut -d '=' -f2`
echo -e "\n\n##### Maximum CPU1 frequency (MHz) #####\n# 1512, 1620, 1728, 1836, 1890, 1944, 1998\n# 2052, 2106, 2160, 2214, 2268, 2322\n" >> $CONFIGFILE
if [ "$MAXF_CPU1" = 2 ]; then
  echo "MAXF_CPU1=1620" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 3 ]; then
  echo "MAXF_CPU1=1728" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 4 ]; then
  echo "MAXF_CPU1=1836" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 5 ]; then
  echo "MAXF_CPU1=1890" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 6 ]; then
  echo "MAXF_CPU1=1944" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 7 ]; then
  echo "MAXF_CPU1=1998" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 8 ]; then
  echo "MAXF_CPU1=2052" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 9 ]; then
  echo "MAXF_CPU1=2106" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 10 ]; then
  echo "MAXF_CPU1=2160" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 11 ]; then
  echo "MAXF_CPU1=2214" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 12 ]; then
  echo "MAXF_CPU1=2268" >> $CONFIGFILE;
elif [ "$MAXF_CPU1" = 13 ]; then
  echo "MAXF_CPU1=2322" >> $CONFIGFILE;
else
  echo "MAXF_CPU1=1512" >> $CONFIGFILE;
fi
else
echo "selected.0=99" > /tmp/aroma/freq1.prop
echo -e "\n\n##### Maximum CPU1 frequency (MHz) #####\n# 1512, 1620, 1728, 1836, 1890, 1944, 1998\n# 2052, 2106, 2160, 2214, 2268, 2322\n" >> $CONFIGFILE
echo "MAXF_CPU1=1512" >> $CONFIGFILE;
fi

if [ -f "/tmp/aroma/freq2.prop" ];
then
MAXF_CPU2=`cat /tmp/aroma/freq2.prop | cut -d '=' -f2`
echo -e "\n\n##### Maximum CPU2 frequency (MHz) #####\n# 1512, 1620, 1728, 1836, 1890, 1944, 1998\n# 2052, 2106, 2160, 2214, 2268, 2322\n" >> $CONFIGFILE
if [ "$MAXF_CPU2" = 2 ]; then
  echo "MAXF_CPU2=1620" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 3 ]; then
  echo "MAXF_CPU2=1728" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 4 ]; then
  echo "MAXF_CPU2=1836" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 5 ]; then
  echo "MAXF_CPU2=1890" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 6 ]; then
  echo "MAXF_CPU2=1944" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 7 ]; then
  echo "MAXF_CPU2=1998" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 8 ]; then
  echo "MAXF_CPU2=2052" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 9 ]; then
  echo "MAXF_CPU2=2106" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 10 ]; then
  echo "MAXF_CPU2=2160'" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 11 ]; then
  echo "MAXF_CPU2=2214" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 12 ]; then
  echo "MAXF_CPU2=2268" >> $CONFIGFILE;
elif [ "$MAXF_CPU2" = 13 ]; then
  echo "MAXF_CPU2=2322" >> $CONFIGFILE;
else
  echo "MAXF_CPU2=1512" >> $CONFIGFILE;
fi
else
echo "selected.0=99" > /tmp/aroma/freq2.prop
echo -e "\n\n##### Maximum CPU2 frequency (MHz) #####\n# 1512, 1620, 1728, 1836, 1890, 1944, 1998\n# 2052, 2106, 2160, 2214, 2268, 2322\n" >> $CONFIGFILE
echo "MAXF_CPU2=1512" >> $CONFIGFILE;
fi

if [ -f "/tmp/aroma/freq3.prop" ];
then
MAXF_CPU3=`cat /tmp/aroma/freq3.prop | cut -d '=' -f2`
echo -e "\n\n##### Maximum CPU3 frequency (MHz) #####\n# 1512, 1620, 1728, 1836, 1890, 1944, 1998\n# 2052, 2106, 2160, 2214, 2268, 2322\n" >> $CONFIGFILE
if [ "$MAXF_CPU3" = 2 ]; then
  echo "MAXF_CPU3=1620" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 3 ]; then
  echo "MAXF_CPU3=1728" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 4 ]; then
  echo "MAXF_CPU3=1836" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 5 ]; then
  echo "MAXF_CPU3=1890" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 6 ]; then
  echo "MAXF_CPU3=1944" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 7 ]; then
  echo "MAXF_CPU3=1998" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 8 ]; then
  echo "MAXF_CPU3=2052" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 9 ]; then
  echo "MAXF_CPU3=2106" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 10 ]; then
  echo "MAXF_CPU3=2160" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 11 ]; then
  echo "MAXF_CPU3=2214" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 12 ]; then
  echo "MAXF_CPU3=2268" >> $CONFIGFILE;
elif [ "$MAXF_CPU3" = 13 ]; then
  echo "MAXF_CPU3=2322" >> $CONFIGFILE;
else
  echo "MAXF_CPU3=1512" >> $CONFIGFILE;
fi
else
echo "selected.0=99" > /tmp/aroma/freq3.prop
echo -e "\n\n##### Maximum CPU3 frequency (MHz) #####\n# 1512, 1620, 1728, 1836, 1890, 1944, 1998\n# 2052, 2106, 2160, 2214, 2268, 2322\n" >> $CONFIGFILE
echo "MAXF_CPU3=1512" >> $CONFIGFILE;
fi

#MINFREQ
MINF=`grep selected.5 /tmp/aroma/cpu.prop | cut -d '=' -f2`
echo -e "\n\n##### Minimum CPU frequency (MHz) #####\n# 81, 162, 270, 384, 595 or 810 are valid frequencies.\n" >> $CONFIGFILE
if [ "$MINF" = 1 ]; then
  echo "MINF=81" >> $CONFIGFILE;
elif [ "$MINF" = 2 ]; then
  echo "MINF=162" >> $CONFIGFILE;
elif [ "$MINF" = 3 ]; then
  echo "MINF=270" >> $CONFIGFILE;
elif [ "$MINF" = 5 ]; then
  echo "MINF=595" >> $CONFIGFILE;
elif [ "$MINF" = 6 ]; then
  echo "MINF=810" >> $CONFIGFILE;
else
  echo "MINF=384" >> $CONFIGFILE;
fi

#UV
UV_LEVEL=`grep selected.3 /tmp/aroma/nrg.prop | cut -d '=' -f2`
echo -e "\n\n##### Level of uV to apply to min frequency #####\n# 0 stock(no uV)\n# 1 -50 mV" >> $CONFIGFILE
echo -e "# 2 -75 mV\n# 3 -100 mV\n# 4 -125 mV\n# 5 -150 mV\n# 6 -175 mV\n" >> $CONFIGFILE
if [ "$UV_LEVEL" = 2 ]; then
  echo "UV_LEVEL=1" >> $CONFIGFILE;
elif [ "$UV_LEVEL" = 3 ]; then
  echo "UV_LEVEL=2" >> $CONFIGFILE;
elif [ "$UV_LEVEL" = 4 ]; then
  echo "UV_LEVEL=3" >> $CONFIGFILE;
elif [ "$UV_LEVEL" = 5 ]; then
  echo "UV_LEVEL=4" >> $CONFIGFILE;
elif [ "$UV_LEVEL" = 6 ]; then
  echo "UV_LEVEL=5" >> $CONFIGFILE;
elif [ "$UV_LEVEL" = 7 ]; then
  echo "UV_LEVEL=6" >> $CONFIGFILE;
else
  echo "UV_LEVEL=0" >> $CONFIGFILE;
fi

#L2/CACHE OC
L2_OC=`grep selected.2 /tmp/aroma/cpu.prop | cut -d '=' -f2`
echo -e "\n\n##### L2/cache OC settings #####\n# 0 stock(1.13GHz-4.26GBps)\n# 1 improved(1.19GHz-4.26GBps)" >> $CONFIGFILE
echo -e "# 2 balanced(1.22GHz-4.66GBps)\n# 3 fast(1.35GHz-4.66GBps)\n# 4 extreme(1.43GHz-4.80GBps)" >> $CONFIGFILE
echo -e "# 5 glitchy(1.49GHz-4.96GBps)\n" >> $CONFIGFILE
if [ "$L2_OC" = 2 ]; then
  echo "L2_OC=1" >> $CONFIGFILE;
elif [ "$L2_OC" = 3 ]; then
  echo "L2_OC=2" >> $CONFIGFILE;
elif [ "$L2_OC" = 4 ]; then
  echo "L2_OC=3" >> $CONFIGFILE;
elif [ "$L2_OC" = 5 ]; then
  echo "L2_OC=4" >> $CONFIGFILE;
elif [ "$L2_OC" = 6 ]; then
  echo "L2_OC=5" >> $CONFIGFILE;
else
  echo "L2_OC=0" >> $CONFIGFILE;
fi

#HOTPLUGDRV
HOTPLUGDRV=`grep selected.3 /tmp/aroma/cpu.prop | cut -d '=' -f2`
echo -e "\n\n##### Hotplug driver Settings #####\n# 0 to enable qualcomm mpdecision (stock)" >> $CONFIGFILE
echo -e "# 1 to enable MSM Hotplug (recommended)\n# 2 to enable intelli-plug\n" >> $CONFIGFILE
if [ "$HOTPLUGDRV" = 1 ]; then
  echo "HOTPLUGDRV=0" >> $CONFIGFILE;
elif [ "$HOTPLUGDRV" = 3 ]; then
  echo "HOTPLUGDRV=2" >> $CONFIGFILE;
else
  echo "HOTPLUGDRV=1" >> $CONFIGFILE;
fi

echo -e "\n\n##############################" >> $CONFIGFILE
#END
