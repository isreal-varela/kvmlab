#!/bin/bash

ansible-playbook -i hosts/ivlab kvm_remove.yml -vv -u ${USER}
