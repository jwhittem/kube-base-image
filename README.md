# kube-base-image

This was created to make building VM base images for Kubernetes easy.

Available virtual machine outputs are:

- KVM

## building

You will need KVM, and packer installed to build.  Simply run `make` to build the image.  Image will be build in output directory.

## base image build

Overview of the image configuration:

- Swap disabled (required for k8s)
- Configures compatible network settings
- Installs [cloud-init] for run once tasks, and for future automation
- Resets host SSH keys
- Allows user provided `authorized_keys` file applied to user `debian` by placing it in `files/` prior to build
- Creates new machine id, and randomizes hostname (both need to be unique in k8s)
- Displays ip address at login screen
- Enables serial console access

See [VERSIONS](scripts/VERSIONS) for what component versions are part of the image build.

*Default username / password is 'debian' this is something you'll want to change once the machines are setup.*

The distribution is the net install of Debian.  The first stage builds a minimal install, and then the kubernetes components are added by running the [scripts](/scripts/)

Packer uses an automatic answer file seen at [preseed](http/preseed.cfg), this is referenced during the initial OS configuration.  VNC is used to alter the VM's linux boot parameters, then this preseed file is served via http, and will automate the install of the OS.  

Next a few application scripts will run, to install the rest of the components before the image is created.

## cluster build

Here are some docs that show how to build a cluster, these should be completed in order:

- [Building a base VM image](kube-base-image.md)
- [Configure VMs, bootstrap cluster](bootstrap.md)
- [Install a Pod network add-on](pod-network.md)
