#!/bin/bash

function __usage {
	echo
	echo "$(basename $0) <kvm name(s)>"
	echo "  where zero or more valid KVM names are listed as parameters"
	echo "  if no parametrs are passed, the default list as defined"
	echo "  within the ansible playbook will be processed."
	echo
	exit
}

function __join {
  local delim=$1 ; shift
  printf "$1"   ; shift
  printf "%s" "${@/#/$delim}"
}

test1=$@
test2=`(echo "$@" | sed -e 's/[!@#$%^&*()~\`<>,\\/:;\|]//g')`
if [ "${test1}" != "${test2}" ]; then
	__usage
	exit 1
fi

list=$(__join "," $@)
if [ -z "${list}" ]; then
	echo Destroy default KVMs
	ansible-playbook -i hosts/ivlab.yml kvm_remove.yml -vv --ask-become-pass --ask-pass --ask-vault-pass -u ${USER} -e '@./secrets/ivlab.yml' -l localhost,ipa1
else
	echo Destroy specific KVMS: ${list}
	ansible-playbook -i hosts/ivlab.yml kvm_remove.yml -vv --ask-become-pass --ask-pass --ask-vault-pass -u ${USER} -e '@./secrets/ivlab.yml' -e "vm_name=${list}" -l localhost,ipa1
fi
