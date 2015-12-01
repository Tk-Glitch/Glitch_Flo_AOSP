#!/sbin/sh

#set optimization level
val5=$(grep selected.2 /tmp/aroma-data/cpu.prop | cut -d '=' -f2)

case $val5 in
	1)
	  l2_opt="l2_opt=0"
	  ;;
	2)
	  l2_opt="l2_opt=1"
	  ;;
	3)
	  l2_opt="l2_opt=2"
	  ;;
	4)
	  l2_opt="l2_opt=3"
	  ;;
	5)
	  l2_opt="l2_opt=4"
	  ;;
	6)
	  l2_opt="l2_opt=5"
	  ;;
esac

#set undervolting
val6=$(grep selected.3 /tmp/aroma-data/nrg.prop | cut -d '=' -f2)

case $val6 in
	1)
	  vdd_uv="vdd_uv=0"
	  ;;
	2)
	  vdd_uv="vdd_uv=1"
	  ;;
	3)
	  vdd_uv="vdd_uv=2"
	  ;;
	4)
	  vdd_uv="vdd_uv=3"
	  ;;
	5)
	  vdd_uv="vdd_uv=4"
	  ;;
	6)
	  vdd_uv="vdd_uv=5"
	  ;;
	7)
	  vdd_uv="vdd_uv=6"
	  ;;
esac

null="abc"

selinux=`grep "item.0.7" /tmp/aroma/misc.prop | cut -d '=' -f2`

if [ "$selinux" = 1 ]; then
echo "cmdline = console=ttyHSL0,115200,n8 androidboot.hardware=flo user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 vmalloc=340M enforcing=0" $l2_opt $vdd_uv $null >> /tmp/cmdline.cfg
else
echo "cmdline = console=ttyHSL0,115200,n8 androidboot.hardware=flo user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 vmalloc=340M enforcing=1" $l2_opt $vdd_uv $null >> /tmp/cmdline.cfg
fi
