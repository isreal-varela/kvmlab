#!/bin/bash

mkdir ~/.ansible/roles
ansible-galaxy collection install -r requirements.yaml
ansible-playbook kvm_provision.yaml

#Uncomment to install additional systems as well
#ansible-playbook kvm_provision.yaml --extra-vars "vm_name=ipa"
