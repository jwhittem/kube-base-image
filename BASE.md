# base image build

Building a base image for kubernetes seems like it should be simpler, there are a few tunable items that are provided by running the packer build here.  Some of them are quality of life items, some are k8s requirements.

- Swap disabled (node workload performance across a cluster would be unpredictable)
- Configures compatible network settings
- Disables password login, and enables your provided authorized keys to the 'debian' user.
- Installs [cloud-init] for run once tasks, and for future automation.
- Resets host SSH keys.
- Creates new machine id, and randomizes hostname (both need to be unique in k8s)
- Displays ip address at login screen

The distribution is the net install of Debian.  The first stage builds a minimal install, and then the kubernetes components are added by running the [scripts](/scripts/)

Packer uses an automatic answer file seen at [preseed](http/preseed.cfg), this is referenced during the initial OS configuration.  VNC is used to alter the VM's linux boot parameters, then this preseed file is served via http, and will automate the install of the OS.  

Next a few application scripts will run, to install the rest of the components before the image is created.

