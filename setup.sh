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

ensure_dir_exists "~/.ansible/roles"

ansible-galaxy collection install -r requirements.yml
ansible-galaxy collection install containers.podman

#ansible-playbook kvm_provision.yml

#Uncomment to install additional systems as well
#ansible-playbook kvm_provision.yml --extra-vars "vm_name=ipa"

# BeetleD added below
#ansible-playbook -i gitlab, kvm_provision.yml -vv -e "vm_name=gitlab" -e "ram_mb=4096" -e "skip_prereqs=true" -u ${USER}
