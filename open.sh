#! /bin/bash

OVERLAY_ROOT="overlay-root.sh"

function close_swap(){
	sudo dphys-swapfile swapoff
	sudo dphys-swapfile uninstall
	sudo update-rc.d dphys-swapfile remove
}

echo "关闭交换空间"

close_swap

echo "交换空间已关闭"

echo "复制overlay"

sudo cp -f $OVERLAY_ROOT /sbin/$OVERLAY_ROOT
sudo chmod a+x /sbin/$OVERLAY_ROOT

echo "复制完成"

echo "修改cmdline.txt"

sudo mount -o remount,rw /boot

sudo cp -f /boot/cmdline.txt /boot/cmdline.txt.bak

sudo sed -i "s/init=\/sbin\/$OVERLAY_ROOT//g" /boot/cmdline.txt
sudo sed -i "s/$/ init=\/sbin\/$OVERLAY_ROOT/" /boot/cmdline.txt

echo "修改完成"

echo "挂载root为只读"

sudo sed -i "2s/defaults,ro/defaults/" /etc/fstab
sudo sed -i "2s/defaults/defaults,ro/" /etc/fstab

echo "挂载完成"

read -p "是否重启？(Y/n)" reboot

if [[ -z $reboot || $reboot == 'y' || $reboot == 'Y' ]]; then
	sudo reboot
fi

exit 0
