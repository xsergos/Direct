#!/bin/bash

iptables -F
if lshw -short -c network | grep 8168 > /dev/null
then
	sed -i '/r8169/d' /etc/modprobe.d/blacklist.conf
	sed -i '/r8168/d' /etc/modules
	wget https://raw.githubusercontent.com/xsergos/inet/main/Network/r8168.deb -O /tmp/r8168.deb
	dpkg -i /tmp/r8168.deb
	rmmod r8169
	modprobe r8168
	echo "blacklist r8169" >> /etc/modprobe.d/blacklist.conf
	echo "r8168" >> /etc/modules
else
	sed -i '/e1000e/d' /etc/modules
	wget https://raw.githubusercontent.com/xsergos/inet/main/Network/e1000e.tar.gz -O /tmp/e1000e.tar.gz
	tar -C /tmp/ -xvf /tmp/e1000e.tar.gz
	cd /tmp/e1000e/src || exit
	make install
	rmmod e1000e
	modprobe e1000e
	echo "e1000e" >> /etc/modules
fi