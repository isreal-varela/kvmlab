#!/bin/bash +x

function ensure_dir_exists()
{
  for dir in "$*"
  {
    if [[ ! -e $dir ]]; then
      mkdir -p $dir
      exit $?
    elif [[ ! -d $dir ]]; then
      echo "$dir already exists but is not a directory" 1>&2
      exit 1
    fi
  }
}

ensure_dir_exists ${HOME}/.ansible/roles

ansible-galaxy collection install -r requirements.yml
ansible-galaxy role       install -r requirements.yml
#ansible-galaxy collection install containers.podman

#ansible-playbook kvm_provision.yml

#Uncomment to install additional systems as well
#ansible-playbook kvm_provision.yml --extra-vars 'vm_name=ipa'

# BeetleD added below
ansible-playbook -i hosts/ivlab kvm_provision.yml -vv -u ${USER} --ask-vault-pass --ask-become-pass --ask-pass
#ansible-playbook -i hosts/nglaptop kvm_provision.yml -vv -u ${USER} -e 'skip_prereqs=true' -e 'net=virbr0' --ask-vault-pass
