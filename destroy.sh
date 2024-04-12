#!/bin/bash

ansible-playbook -i kvmtest, kvm_remove.yaml -vv -e "vm_name=gl-test" -u beetled
