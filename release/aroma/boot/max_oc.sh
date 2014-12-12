#!/sbin/sh

#set max_oc
val0=$(cat /tmp/aroma-data/freq0.prop | cut -d '=' -f2)

case $val0 in

	1)
	  max_oc0="max_oc0=1512000"
	  ;;
	2)
	  max_oc0="max_oc0=1620000"
	  ;;
	3)
	  max_oc0="max_oc0=1728000"
	  ;;
	4)
	  max_oc0="max_oc0=1836000"
	  ;;
  	5)
	  max_oc0="max_oc0=1890000"
	  ;;
  	6)
	  max_oc0="max_oc0=1944000"
	  ;;
	7)
	  max_oc0="max_oc0=1998000"
	  ;;
	8)
	  max_oc0="max_oc0=2052000"
	  ;;
	9)
	  max_oc0="max_oc0=2106000"
	  ;;
	10)
	  max_oc0="max_oc0=2160000"
	  ;;
	11)
	  max_oc0="max_oc0=2214000"
	  ;;
	12)
	  max_oc0="max_oc0=2268000"
	  ;;
	13)
	  max_oc0="max_oc0=2322000"
	  ;;
esac

if [ ! -e /tmp/aroma-data/freq1.prop ]; then
	cp /tmp/aroma-data/freq0.prop /tmp/aroma-data/freq1.prop;
	cp /tmp/aroma-data/freq0.prop /tmp/aroma-data/freq2.prop;
	cp /tmp/aroma-data/freq0.prop /tmp/aroma-data/freq3.prop;
fi

val1=$(cat /tmp/aroma-data/freq1.prop | cut -d '=' -f2)
case $val1 in

	1)
	  max_oc1="max_oc1=1512000"
	  ;;
	2)
	  max_oc1="max_oc1=1620000"
	  ;;
	3)
	  max_oc1="max_oc1=1728000"
	  ;;
	4)
	  max_oc1="max_oc1=1836000"
	  ;;
  	5)
	  max_oc1="max_oc1=1890000"
	  ;;
  	6)
	  max_oc1="max_oc1=1944000"
	  ;;
	7)
	  max_oc1="max_oc1=1998000"
	  ;;
	8)
	  max_oc1="max_oc1=2052000"
	  ;;
	9)
	  max_oc1="max_oc1=2106000"
	  ;;
	10)
	  max_oc1="max_oc1=2160000"
	  ;;
	11)
	  max_oc1="max_oc1=2214000"
	  ;;
	12)
	  max_oc1="max_oc1=2268000"
	  ;;
	13)
	  max_oc1="max_oc1=2322000"
	  ;;
esac

val2=$(cat /tmp/aroma-data/freq2.prop | cut -d '=' -f2)
case $val2 in

	1)
	  max_oc2="max_oc2=1512000"
	  ;;
	2)
	  max_oc2="max_oc2=1620000"
	  ;;
	3)
	  max_oc2="max_oc2=1728000"
	  ;;
	4)
	  max_oc2="max_oc2=1836000"
	  ;;
  	5)
	  max_oc2="max_oc2=1890000"
	  ;;
  	6)
	  max_oc2="max_oc2=1944000"
	  ;;
	7)
	  max_oc2="max_oc2=1998000"
	  ;;
	8)
	  max_oc2="max_oc2=2052000"
	  ;;
	9)
	  max_oc2="max_oc2=2106000"
	  ;;
	10)
	  max_oc2="max_oc2=2160000"
	  ;;
	11)
	  max_oc2="max_oc2=2214000"
	  ;;
	12)
	  max_oc2="max_oc2=2268000"
	  ;;
	13)
	  max_oc2="max_oc2=2322000"
	  ;;
esac

val3=$(cat /tmp/aroma-data/freq3.prop | cut -d '=' -f2)
case $val3 in

	1)
	  max_oc3="max_oc3=1512000"
	  ;;
	2)
	  max_oc3="max_oc3=1620000"
	  ;;
	3)
	  max_oc3="max_oc3=1728000"
	  ;;
	4)
	  max_oc3="max_oc3=1836000"
	  ;;
  	5)
	  max_oc3="max_oc3=1890000"
	  ;;
  	6)
	  max_oc3="max_oc3=1944000"
	  ;;
	7)
	  max_oc3="max_oc3=1998000"
	  ;;
	8)
	  max_oc3="max_oc3=2052000"
	  ;;
	9)
	  max_oc3="max_oc3=2106000"
	  ;;
	10)
	  max_oc3="max_oc3=2160000"
	  ;;
	11)
	  max_oc3="max_oc3=2214000"
	  ;;
	12)
	  max_oc3="max_oc3=2268000"
	  ;;
	13)
	  max_oc3="max_oc3=2322000"
	  ;;
esac

#set min_clock
val4=$(grep selected.5 /tmp/aroma-data/cpu.prop | cut -d '=' -f2)

case $val4 in
	1)
	  min_clock="min_clock=81000"
	  ;;
	2)
	  min_clock="min_clock=162000"
	  ;;
	3)
	  min_clock="min_clock=270000"
	  ;;
	4)
	  min_clock="min_clock=384000"
	  ;;
	5)
	  min_clock="min_clock=594000"
	  ;;
  	6)
	  min_clock="min_clock=810000"
	  ;;
esac

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

echo "cmdline = console=ttyHSL0,115200,n8 androidboot.hardware=flo user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 vmalloc=340M" $l2_opt $vdd_uv $max_oc0 $max_oc1 $max_oc2 $max_oc3 $min_clock $null >> /tmp/cmdline.cfg
