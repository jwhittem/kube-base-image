#!/bin/bash

source /home/debian/kube-base-image/scripts/VERSIONS
curl -fsSL https://pkgs.k8s.io/core:/stable:/v$K8S_VERSION/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$K8S_VERSION/deb/ /" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
#apt-get install -y kubelet=$K8S_BUILD kubeadm=$K8S_BUILD kubectl=$K8S_BUILD
apt-mark hold kubelet kubeadm kubectl
