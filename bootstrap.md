
## Configure networking

When using KVM there are two types of networks most commonly used, NAT and bridge mode.  If you want to have other computers attaching to your Kubernetes nodes it's recommended to use bridge mode.  Depending on your distribution this process may be slightly different, and is out of scope for this document.

Assuming you did configure bridge mode, you'll want to pick out a few static IP's for your nodes.  You can set these via DHCP reservations, or alternatively by updating the `/etc/network/interfaces` file.

After configuring a static IP, reboot the VM for it to take effect, and rename the node accordingly.

## Bootstrap master node

The initial boot strapping is pretty straight forward.  Assuming everything is built correctly, you can type `sudo kubeadm init` to begin this process.  After it's complete it will provide a token snippet to be used on the worker nodes, the bootstrap message will look like this:

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.1.10:6443 --token <token> \
	--discovery-token-ca-cert-hash <sha>

```

The base build includes `kubectl` so you can set up the config on the master node, and / or copy it off you another workstation to administer remotely.  Note, this config file will have all RBAC privileges in the cluster.

Repeat the same process of setting up a static IP on the worker nodes, reboot and then bootstrap them with the join command (you may need to add `sudo`)

After the nodes have joined, you can then choose / add a [pod network add-on](pod-network.md)