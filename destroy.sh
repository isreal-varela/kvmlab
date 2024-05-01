#!/bin/bash

ansible-playbook -i hosts/ivlab kvm_remove.yml -vv --ask-become-pass --ask-pass -u ${USER}
#ansible-playbook -i hosts/nglaptop kvm_remove.yml -vv --ask-become-pass --ask-pass -u ${USER}
