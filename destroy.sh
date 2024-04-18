#!/bin/bash

ansible-playbook -i gitlab, kvm_remove.yml -vv -u ${USER}
