#!/bin/bash +x

function __usage {
	echo
	echo "$(basename $0) <environment name>"
	echo "  where <environment name> is used to determined the appropriate inventory"
	echo "    and secrets files used for the playbook execution"
	echo
	exit 1
}

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

test1=$@
test2=`(echo "$@" | sed -e 's/[!@#$%^&*()~\`<>,\\/:;\|]//g')`
if [ "${test1}" != "${test2}" ]; then
	echo "Invalid characters in arguments!"
	__usage
fi
boolParamIssue=0

ensure_dir_exists ${HOME}/.ansible/roles

if ! [ -n "$1" ]; then
	echo "Environment not specified!"
	__usage
	exit 1
fi

strEnvName=$1
if ! [ -f ./hosts/$strEnvName.yml ]; then
	echo "./hosts/${strEnvName}.yml file not found!"
	boolParamIssue=1
fi
if ! [ -f ./secrets/${strEnvName}.yml ]; then
	echo "./secrets/${strEnvName}.yml file not found!"
	boolParamIssue=1
fi
if [[ boolParamIssue -ne 0 ]]; then
	__usage
fi

echo Using the following files:
echo \- hosts/${strEnvName}.yml for playbook "-i" parameter
echo \-  secrets/${strEnvName}.yml for playbook extraVars
echo

ansible-galaxy collection install -r requirements.yml
ansible-galaxy role       install -r requirements.yml
#ansible-galaxy collection install containers.podman
echo

echo "Command being launched:"
echo "ansible-playbook -i hosts/${strEnvName}.yml kvm_provision.yml -vv -u ${USER} -e @./secrets/${strEnvName}.yml --ask-vault-pass --ask-become-pass --ask-pass"
ansible-playbook -i hosts/${strEnvName}.yml kvm_provision.yml -vv -u ${USER} -e @./secrets/${strEnvName}.yml --ask-vault-pass --ask-become-pass --ask-pass
