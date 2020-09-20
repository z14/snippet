#!/bin/bash
#
# vim:ft=sh

# Automount usb stick, find update.txz, extract and source update.sh

############### Variables ###############
# !!! IMPORTANT !!!
# Make sure directory structure in update.txz is update/update.sh
ball=update.txz
dir=${ball%.txz}
script=${ball/txz/sh}
mount_point=$(mktemp -d XXXXX)
pass=s

############### Functions ###############
cleanup(){
    rm -d $mount_point
    rm $dir -rf
}
trap cleanup EXIT

############### Main Part ###############
rm $dir -rf # In case last run accidentally exit and trap not triggered

# sdb, sdc... it may change
for i in {b..z}
do
    if [ -b /dev/sd$i ]; then
        device=/dev/sd$i
        break
    fi
done

if [ ! -b "$device" ]; then
    say 没有检测到U盘
    exit
fi

mkdir -p $mount_point

for usb in $device*
do
    echo $pass | sudo -S mount $usb $mount_point
    if [ -f $mount_point/$ball ]; then
        tar xf $mount_point/$ball
        echo $pass | sudo -S umount $mount_point
        break
    else
        echo $pass | sudo -S umount $mount_point
    fi
done

if [ -f $dir/$script ]; then
    . $dir/$script
    say 正在执行脚步
else
    say 没有找到脚本
fi

say 可以拔掉U盘了
