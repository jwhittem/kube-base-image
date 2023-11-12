#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
update-grub

echo "localepurge	localepurge/use-dpkg-feature	boolean	true" | debconf-set-selections
echo "localepurge	localepurge/nopurge	multiselect	en, en_US.UTF-8"  | debconf-set-selections

apt-get update
apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    cloud-guest-utils \
    cloud-init \
    curl \
    gnupg \
    localepurge \
    lsb-release \
    nfs-common \
    qemu-guest-agent \
    vim

install -m 644 /home/debian/kube-base-image/files/interfaces /etc/network/interfaces
install -m 644 /home/debian/kube-base-image/files/1_debian_config.cfg /etc/cloud/cloud.cfg.d/1_debian_config.cfg
install -m 644 /home/debian/kube-base-image/files/issue /etc/issue
install -m 755 -D /home/debian/kube-base-image/files/run-once.sh /var/lib/cloud/scripts/per-instance/run-once.sh
install -m 755 -D /home/debian/kube-base-image/files/on-boot.sh /var/lib/cloud/scripts/per-boot/on-boot.sh
install -m 644 -D /home/debian/kube-base-image/files/no-clear.conf /etc/systemd/system/getty@tty1.service.d/no-clear.conf
install -m 644  /home/debian/kube-base-image/files/vimrc /root/.vimrc

if test -f /home/debian/kube-base-image/files/authorized_keys; then
    install -m 644 -D -o debian -g debian /home/debian/kube-base-image/files/authorized_keys /home/debian/.ssh/authorized_keys
fi

systemctl add-wants multi-user.target cloud-init.target
systemctl enable qemu-guest-agent
systemctl enable --now serial-getty@ttyS0.service
