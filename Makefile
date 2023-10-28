
build: init
	packer build base.pkr.hcl

init:
	packer init -upgrade base.pkr.hcl 
