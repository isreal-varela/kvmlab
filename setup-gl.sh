#!/bin/bash

#mkdir ~/.ansible/roles
#ansible-galaxy collection install -r requirements.yml
#ansible-playbook kvm_provision.yml

#Uncomment to install additional systems as well
#ansible-playbook kvm_provision.yml --extra-vars "vm_name=ipa"

# BeetleD added below
ansible-playbook gl_provision.yml -vv -l gitlab
