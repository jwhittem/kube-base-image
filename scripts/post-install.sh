#!/bin/bash

apt-get upgrade
apt-get autoremove --yes --purge $(dpkg -l "linux-image*" | grep "^ii" | grep -v linux-image-amd64 | head -n -1 | cut -d " " -f 3)

apt-get install --yes deborphan
apt-get autoremove \
  console-setup \
  $(deborphan) \
  deborphan \
  dictionaries-common \
  iamerican \
  ibritish \
  localepurge \
  task-english \
  tasksel \
  tasksel-data \
  --purge --yes

apt-get clean

find \
   /var/cache/apt \
   -mindepth 1 -print -delete

rm -vf \
   /etc/adjtime \
   /etc/ssh/*key* \
   /var/cache/ldconfig/aux-cache \
   /var/lib/systemd/random-seed \
   ~/.bash_history \
   ${SUDO_USER}/.bash_history 
   
truncate -s 0 /etc/machine-id
rm -rf /home/debian/kube-base-image
fstrim --all --verbose
