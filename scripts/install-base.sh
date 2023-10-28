#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# configure grub
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
update-grub

# Configure localepurge to remove unused locales. This makes the image smaller.
echo "localepurge	localepurge/use-dpkg-feature	boolean	true" | debconf-set-selections
echo "localepurge	localepurge/nopurge	multiselect	en, en_US.UTF-8"  | debconf-set-selections

# Disable floppy support 
echo "blacklist floppy" > /etc/modprobe.d/blacklist-floppy.conf
rmmod floppy
update-initramfs -u

apt-get update
apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    cloud-guest-utils \
    cloud-init \
    curl \
    git \
    gnupg \
    localepurge \
    lsb-release \
    make \
    qemu-guest-agent \
    vim \
    wget

mkdir -p /var/lib/cloud/scripts/per-instance
mkdir -p /etc/systemd/system/getty@tty1.service.d/

install -m 644 /home/debian/k8s-dev-lab/files/interfaces /etc/network/interfaces
install -m 644 /home/debian/k8s-dev-lab/files/1_debian_config.cfg /etc/cloud/cloud.cfg.d/1_debian_config.cfg
install -m 644 /home/debian/k8s-dev-lab/files/issue /etc/issue
install -m 755 /home/debian/k8s-dev-lab/files/run-once.sh /var/lib/cloud/scripts/per-instance/run-once.sh
install -m 644 /home/debian/k8s-dev-lab/files/no-clear.conf /etc/systemd/system/getty@tty1.service.d/no-clear.conf

systemctl add-wants multi-user.target cloud-init.target
systemctl enable qemu-guest-agent

# enable serial console
systemctl enable --now serial-getty@ttyS0.service
