#!/sbin/sh
#================================#
#          k-y-u-b-e-y           #
#        © 2021 UKΛz-XDΛ         #
#================================#

interface="${1}"
updater_fd="${2}"
ui_print() {
	echo -en "ui_print ${1}\n" > /proc/self/fd/"${updater_fd}"
	echo -en "ui_print\n" > /proc/self/fd/"${updater_fd}"
}

KYU=/tmp/ukazxda/Kyubey
KYU_PROP=/tmp/ukazxda/Kyubey.prop
MAGIA1=$1;MAGIA2=$2;MAGIA3=$3

if [ $MAGIA3 = "check_device" ]; then
	if [ `getprop ro.boot.bootloader | grep 'G610'` ]; then echo check_device=1 >> $KYU_PROP;echo G610=1 >> $KYU_PROP;else echo;exit;fi
#	if [ `getprop ro.boot.bootloader | grep 'G611'` ]; then echo check_device=1 >> $KYU_PROP;echo G611=1 >> $KYU_PROP;else echo;exit;fi
	echo check_device=0 >> $KYU_PROP
exit
fi

if [ $MAGIA1 = "check_volume" ]; then
	# Caminho para a partição SYSTEM
	SYSTEM_PARTITION="/dev/block/platform/13540000.dwmmc0/by-name/SYSTEM"
	VENDOR_PARTITION="/dev/block/platform/13540000.dwmmc0/by-name/VENDOR"
	
	# Caminho para o arquivo build.prop
	BUILD_PROP_PATH="/tmp/ukazxda/Kyubey.prop"

	# Obtém o tamanho da partição SYSTEM em MB
	SYSTEM_SIZE_MB=$(blockdev --getsize64 $SYSTEM_PARTITION | awk '{print $1/1024/1024}')
	VENDOR_SIZE_MB=$(blockdev --getsize64 $VENDOR_PARTITION | awk '{print $1/1024/1024}')

	# Valor de referência em MB
	REFERENCE_VALUE_SYSTEM=$(grep 'SYSTEM_VOLUME_MAX=' $BUILD_PROP_PATH | cut -d'=' -f2)
	REFERENCE_VALUE_VENDOR=$(grep 'VENDOR_VOLUME_MAX=' $BUILD_PROP_PATH | cut -d'=' -f2)

	if [ $(echo "$SYSTEM_SIZE_MB < $REFERENCE_VALUE_SYSTEM" | bc) -eq 1 ]; then
	  echo "check_volume_system=0" >> $BUILD_PROP_PATH
	else
	  echo "check_volume_system=1" >> $BUILD_PROP_PATH
	fi
	if [ $(echo "$VENDOR_SIZE_MB < $REFERENCE_VALUE_VENDOR" | bc) -eq 1 ]; then
	  echo "check_volume_vendor=0" >> $BUILD_PROP_PATH
	else
	  echo "check_volume_vendor=1" >> $BUILD_PROP_PATH
	fi
exit
fi

if [ $MAGIA1 = "check_rom" ]; then
	if [ -e /system/build.prop ] || [ -e /system/system/build.prop ]; then
		echo system_check=1 >> $KYU_PROP
		else echo system_check=0 >> $KYU_PROP
	fi
	if [ -e /vendor/build.prop ]; then
		echo vendor_check=1 >> $KYU_PROP
		else echo vendor_check=0 >> $KYU_PROP
	fi
exit
fi

if [ $MAGIA1 = "wipe_data" ]; then
	cd /data
	for i in `ls -a` ; do
	if [ "$i" != "media" ] ; then
		if [ "$i" != "multiboot" ] ; then
			rm -fR "$i"
		fi
	fi
	done
	rm -fR /data/media/0/.*
	rm -fR /data/media/0/Android
	rm -fR /data/media/0/data
	rm -fR /data/media/obb/*
exit
fi

if [ $MAGIA3 = "check_vendor" ]; then
cd /tmp/ukazxda
chmod 777 *
	if [ -z `./parted /dev/block/mmcblk0 p | grep VENDOR` ]
		then echo check_vendor=0 >> $KYU_PROP
		else if [ -z `cat /etc/recovery.fstab | grep VENDOR` ]
			then echo check_vendor=0 >> $KYU_PROP
			else echo check_vendor=1 >> $KYU_PROP
		fi
	fi
cd ../..
exit
fi

if [ $MAGIA3 = "create_vendor" ]; then
ZIP=/tmp/ukazxda/vendor.zip
cd /tmp
rm -rf META-INF spaget
unzip -o "$ZIP"
cd spaget
chmod 777 *
oldsize=/efs/spaget/syss


if [ -z `getprop ro.boot.bootloader | grep '[JG][765][310][01]'` ]; then
    exit
fi

if [ `getprop ro.boot.bootloader | grep 'J530'` ]; then
	syspart=18
	cacpart=19
	hidpart=20
fi
if [ `getprop ro.boot.bootloader | grep 'J730'` ]; then
	syspart=18
	cacpart=19
	hidpart=20
fi
if [ `getprop ro.boot.bootloader | grep 'J710'` ]; then
	syspart=20
	cacpart=21
	hidpart=22
fi
if [ `getprop ro.boot.bootloader | grep 'J701'` ]; then
	syspart=18
	cacpart=19
	hidpart=20
fi
if [ `getprop ro.boot.bootloader | grep 'G610'` ]; then
	syspart=21
	cacpart=22
	hidpart=23
fi

if [ -z `./parted /dev/block/mmcblk0 p | grep VENDOR` ]
	then
	partition=0
	else
	partition=1
fi
if [ -z `cat /etc/recovery.fstab | grep VENDOR` ]
	then
	recovery=0
	else
	recovery=1
fi

ui_print " "
ui_print "<@center><b><#4c1239>Kyubey</#></b>"
ui_print "<@center><b>@xda-developers</b></#>"
ui_print "<@center>Exynos7870 CreateVendor"
ui_print "<@center>Modded by Ananjaser1211"
ui_print "<@center>Coded by corsicanu"
ui_print " "
sleep 2

if [ -e $KYU/pt ]; then ui_print "<@center><#19441d>Criando partição do vendor...</#>"; fi
if [ -e $KYU/en ]; then ui_print "<@center><#19441d>Creating vendor partition...</#>"; fi
sleep 2

if [ -e $KYU/pt ]; then ui_print "<@center>Calculando partições originais"; fi
if [ -e $KYU/en ]; then ui_print "<@center>Calculating original partitions"; fi
	syss=`./parted /dev/block/mmcblk0 p | grep RESERVED2 | cut -c17-22 | tr 'MB' ' '`
	syse=`./parted /dev/block/mmcblk0 p | grep SYSTEM | cut -c17-22 | tr 'MB' ' '`
	cacs=`./parted /dev/block/mmcblk0 p | grep SYSTEM | cut -c17-22| tr 'MB' ' '`
	cace=`./parted /dev/block/mmcblk0 p | grep CACHE | cut -c17-22| tr 'MB' ' '`
	hids=`./parted /dev/block/mmcblk0 p | grep CACHE | cut -c17-22| tr 'MB' ' '`
	hide=`./parted /dev/block/mmcblk0 p | grep CP_DEBUG | cut -c7-16 | tr 'MB' ' '`

if [ $partition = "0" ]; then
if [ -e $KYU/pt ]; then ui_print "<@center>Fazendo backup de partições originais"; fi
if [ -e $KYU/en ]; then ui_print "<@center>Backing up original partitions"; fi

	mount /efs
	mkdir -p /efs/spaget
	echo $syss > /efs/spaget/syss
	echo $syse > /efs/spaget/syse
	echo $cacs > /efs/spaget/cacs
	echo $cace > /efs/spaget/cace
	echo $hids > /efs/spaget/hids
	echo $hide > /efs/spaget/hide
	umount /efs
	sync
fi

	umount /system
	umount /cache
	umount /hidden
	umount /vendor

if [ $partition = "0" ]; then
if [ -e $KYU/pt ]; then ui_print "<@center>patching partições"; fi
if [ -e $KYU/en ]; then ui_print "<@center>patching partitions"; fi
	cd /tmp/spaget

	# Load sizes
	syss=`./parted /dev/block/mmcblk0 p | grep RESERVED2 | cut -c17-22 | tr 'MB' ' '`
	syse=`./parted /dev/block/mmcblk0 p | grep SYSTEM | cut -c17-22 | tr 'MB' ' '`
	cacs=`./parted /dev/block/mmcblk0 p | grep SYSTEM | cut -c17-22| tr 'MB' ' '`
	cace=`./parted /dev/block/mmcblk0 p | grep CACHE | cut -c17-22| tr 'MB' ' '`
	hids=`./parted /dev/block/mmcblk0 p | grep CACHE | cut -c17-22| tr 'MB' ' '`
	hide=`./parted /dev/block/mmcblk0 p | grep CP_DEBUG | cut -c7-16 | tr 'MB' ' '`

	# Cut sizes
	syse=$(($syse - 150))	
	cacs=$syse	
	cace=$(($cacs + 20))	
	hids=$cace

	# Format partitions
	./parted /dev/block/mmcblk0 rm $syspart Yes -s	
	./parted /dev/block/mmcblk0 rm $cacpart Yes -s
	./parted /dev/block/mmcblk0 rm $hidpart Yes -s
	# Make System
	./parted /dev/block/mmcblk0 mkpart ext4 $syss $syse --s	
	./parted /dev/block/mmcblk0 name $syspart SYSTEM --s	
	# Make Cache	
	./parted /dev/block/mmcblk0 mkpart ext4 $cacs $cace --s	
	./parted /dev/block/mmcblk0 name $cacpart CACHE --s		
	# Make Vendor		
	./parted /dev/block/mmcblk0 mkpart ext4 $hids $hide --s	
	./parted /dev/block/mmcblk0 name $hidpart VENDOR --s		
	# Write disk label
	./parted /dev/block/mmcblk0 set $syspart msftdata on --s	
	./parted /dev/block/mmcblk0 set $cacpart msftdata on --s			
	./parted /dev/block/mmcblk0 set $hidpart msftdata on --s

	mke2fs -b 4096 -T ext4 /dev/block/mmcblk0p$syspart
	mke2fs -b 4096 -T ext4 /dev/block/mmcblk0p$cacpart
	mke2fs -b 4096 -T ext4 /dev/block/mmcblk0p$hidpart
fi
	if [ $recovery = "0" ]; then
		ui_print "<@center>patching recovery"
		sleep 5
	fi
	if [ $recovery = "0" ]; then
		cd /tmp/spaget
		unzip /tmp/spaget/spaget.zip META-INF/com/google/android/* -d /tmp/spaget
		chmod 755 META-INF/com/google/android/update-binary
		exec META-INF/com/google/android/update-binary "dummy" "0" /tmp/spaget/spaget.zip
	fi
sync
exit
fi
