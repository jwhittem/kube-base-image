
build-kvm: tidy
	packer init -upgrade base-kvm.pkr.hcl
	packer build base-kvm.pkr.hcl	 

tidy:
	rm -rf output/
