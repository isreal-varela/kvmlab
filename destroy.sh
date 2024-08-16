#!/bin/bash

function __usage {
	echo
	echo "$(basename $0) <environment name> <ipa hostname> [<kvm name(s)]"
	echo "  where <environment name> is used to determined the appropriate inventory"
	echo "    and secrets files used for the playbook execution"
	echo ""
	echo "  where <ipa hostname> denotes the hostname (short or long) containing the"
	echo "    FreeIPA instance from which the KVMs should be deleted"
	echo ""
	echo "  where, optionally, valid KVM names are listed as parameters"
	echo "  if no KVM names  are passed, the default list as defined"
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

strEnvName=$1
shift 1
if ! [ -f ./hosts/$strEnvName.yml ]; then
	echo "./hosts/${strEnvName}.yml file not found!"
	boolParamIssue=1
fi
if ! [ -f ./secrets/${strEnvName}.yml ]; then
	echo "./secrets/${strEnvName}.yml file not found!"
	boolParamIssue=1
fi

strIPAHost=$1
shift
if [[ -z "$strIPAHost" ]]; then
	echo "IPA Host not specified!"
	boolParamIssue=1
fi

if [[ boolParamIssue -ne 0 ]]; then
	__usage
fi

list=$(__join "," $@)
if [ -z "${list}" ]; then
	echo Destroy default KVMs
	ansible-playbook -i hosts/${strEnvName}.yml kvm_remove.yml -vv --ask-become-pass --ask-pass --ask-vault-pass -u ${USER} -e @./secrets/${strEnvName}.yml -l localhost,${strIPAHost}
else
	echo Destroy specific KVMS: ${list}
	ansible-playbook -i hosts/${strEnvName}.yml kvm_remove.yml -vv --ask-become-pass --ask-pass --ask-vault-pass -u ${USER} -e @./secrets/${strEnvName}.yml -e "vm_name=${list}" -l localhost,${strIPAHost}
fi
