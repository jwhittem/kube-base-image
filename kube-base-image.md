There are a number of tunable parameters, and configurations needed in order to bootstrap a kubernetes node.  To simplify this process we have created a repository you can use to build an image.


To get started with the build, you will need a few things on your host computer:

- A linux PC, or drive with linux installed
- Linux KVM installed, with virtualization enabled in your system bios.
- [packer](https://www.packer.io/) installed
- Makefile tools


After you have verified these have been installed, you can clone the repository: [kube-base-image](https://github.com/kubedevlab/kube-base-image)

Navigate into the directory, one thing you may consider useful is to symlink your ssh public key, into the `files/` directory so you have that option to log into the nodes.

Depending on your home folder, that may look something like this: `ln -s ~/.ssh/id_rsa.pub files/authorized_keys`

After this you can run `make` to build the KVM image, note the default behavior is that you won't see the VM screen output, but you can adjust that behavior but updating the `base-kvm.pkr.hcl` file, updating this line to false: `headless = true`

After about 5-10 minutes you should have a configured debian base image under `output`

You can copy this image 2-3 times, for each VM you want to bootstrap, for example one master, two workers.  Use virt-manager, or virsh to import these disk images into KVM for later use.  It's recommended to give the workers 4GB or more of RAM.

Default Username / Password is `debian` you may use SSH, console, or serial access to login to the node.
