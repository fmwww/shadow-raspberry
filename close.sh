#! /bin/bash

OVERLAY_ROOT="overlay-root.sh"

echo "挂载root为可写"

sudo mount -o remount,rw /boot

sudo mount -o remount,rw /ro

echo "挂载成功"

echo "修改cmdline.txt"

sudo sed -i "s/init=\/sbin\/$OVERLAY_ROOT//g" /boot/cmdline.txt

echo "修改完毕"

echo "修改/etc/fstab"

sudo sed -i "2s/defaults\,ro/defaults/" /etc/fstab

echo "修改完毕"

read -p "是否重启？(Y/n)" reboot

if [[ -z $reboot || $reboot == 'y' || $reboot == 'Y' ]]; then
	sudo reboot
fi

exit 0