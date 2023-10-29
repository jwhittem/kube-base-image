#!/bin/bash

RAND=$(openssl rand -hex 3)
HOSTNAME=k8s-node-$RAND

echo $HOSTNAME > /etc/hostname
sed -i "s/debian/$HOSTNAME/g" /etc/hosts
dpkg-reconfigure openssh-server
reboot
