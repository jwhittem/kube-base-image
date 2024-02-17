#!/bin/bash

source /home/debian/kube-base-image/scripts/VERSIONS
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install -y containerd.io=$CONTAINERD_VERSION

mkdir -p /opt/cni/bin
curl -fsSL https://github.com/containernetworking/plugins/releases/download/v$CNI_PLUGINS_VERSION/cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz --output cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz
rm cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz 

## set up bridge fwd
install -m 644 /home/debian/kube-base-image/files/k8s-modules.conf /etc/modules-load.d/k8s-modules.conf
# ipv4.ip_forward 
install -m 644 /home/debian/kube-base-image/files/k8s-sysctl.conf /etc/sysctl.d/k8s-sysctl.conf 

systemctl stop containerd
install -m 644 /home/debian/kube-base-image/files/config.toml /etc/containerd/config.toml 
