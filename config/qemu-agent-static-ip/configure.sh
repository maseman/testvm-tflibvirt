#!/bin/sh

cat > /etc/network/interfaces <<-EOF
	iface lo inet loopback
	iface eth0 inet static
		address 192.168.111.111
EOF

echo 'GA_PATH="/dev/vport0p1"' >> /etc/conf.d/qemu-guest-agent

ln -s networking /etc/init.d/net.lo
ln -s networking /etc/init.d/net.eth0

rc-update add acpid default
rc-update add crond default
rc-update add qemu-guest-agent default
rc-update add net.eth0 default
rc-update add net.lo boot
