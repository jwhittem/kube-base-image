# kube-base-image

This was created to make building VM base images for Kubernetes easy.

Available virtual machine outputs are:

- KVM

## base image build

Overview of the image configuration:

- Swap disabled (node workload performance across a cluster would be unpredictable)
- Configures compatible network settings
- Installs [cloud-init] for run once tasks, and for future automation.
- Resets host SSH keys
- Creates new machine id, and randomizes hostname (both need to be unique in k8s)
- Displays ip address at login screen
- Enables serial console access

*Default username / password is 'debian' this is something you'll want to change once the machines are setup.*

The distribution is the net install of Debian.  The first stage builds a minimal install, and then the kubernetes components are added by running the [scripts](/scripts/)

Packer uses an automatic answer file seen at [preseed](http/preseed.cfg), this is referenced during the initial OS configuration.  VNC is used to alter the VM's linux boot parameters, then this preseed file is served via http, and will automate the install of the OS.  

Next a few application scripts will run, to install the rest of the components before the image is created.
