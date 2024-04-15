#!/bin/bash

ansible-playbook -i gitlab, kvm_remove.yaml -vv -e "vm_name=gitlab" -u beetled
