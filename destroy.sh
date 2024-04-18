#!/bin/bash

ansible-playbook -i gitlab, kvm_remove.yml -vv -e "vm_name=gitlab" -u ${USER}
