#!/bin/bash

mkdir ~/.ansible/roles
ansible-galaxy collection install -r requirements.yaml
#ansible-playbook kvm_provision.yaml

#Uncomment to install additional systems as well
#ansible-playbook kvm_provision.yaml --extra-vars "vm_name=ipa"
# BeetleD added below
#ansible-playbook -i beetled-ng, kvm_provision.yaml -vvvv -e "vm_name=test"
#rm -f ~/VM/test.qcow2
#ansible-playbook -i kvmtest, kvm_provision.yaml -vv -e "vm_name=gl-test" -e "ram_mb=4096" -e "net=virbr0" -e "skip_prereqs=true" -u beetled
#ansible-playbook -i kvmtest, kvm_provision.yaml -vv -e "vm_name=gitlab" -e "ram_mb=4096" -e "net=virbr0" -e "skip_prereqs=true" -e "base_image_name=rhel-9.3-x86_64-kvm.qcow2" -u beetled
#ansible-playbook -i kvmtest, kvm_provision.yaml -vv -e "vm_name=gitlab" -e "ram_mb=4096" -e "net=virbr0" -e "skip_prereqs=true" -e "base_image_name=rocky9-template.img" -e "libvirt_pool_dir=/srv/vmdisks" -u beetled
ansible-playbook -i kvmtest, kvm_provision.yaml -vv -e "vm_name=gitlab" -e "ram_mb=4096" -e "net=virbr0" -e "skip_prereqs=true" -e "pool_dir=/srv/vmdisks" -u beetled
