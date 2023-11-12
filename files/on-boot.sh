#!/bin/bash

IP=$(ip -f inet addr show enp1s0 | awk '/inet / {print $2}' | cut -f1 -d'/' | sed 's/\./-/g')
CURRENT_HOSTNAME=$(hostname)
NEW_HOSTNAME=node-$IP

hostnamectl set-hostname $NEW_HOSTNAME
sed -i "s/$CURRENT_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
