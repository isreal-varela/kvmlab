Run the setup script and it will install all required components. 
The network is set up for NAT so might need to update some stuff in the future

The following "roles" have been defined within the playbook configuration for use when deploying any KVM instance.  A KVM is currently defined within the 'kvm_list' variable consisting of 1 or more items (KVMs).  Each item is actually an object defined with the following properties:

- name = the unique short-name for the host within the environment.  Concatenated with the overall 'dns_name' value to produce a fully qualified domain name that will be registered within the IPA component and, temporarily, included within the consolidate 'hosts' file.
- ip_addr = the IP address assigned to the host during provisioning and included in both 'hosts' file and IPA registered host.
- roles = array of host specific roles to determine what add'l components to deploy onto said host.
- cpus (optional) = number of vCPUs allocated to host during initial provisioning.  Used to override "default" value (vm_vcpus).
- ram_mb (optional) = amount of RAM/memory (in MB) to allocate to host during initial provisioning.  Used to override "default" value (vm_ram_mb).
- rt_disk (optional) = amount of disk space to allocate to host for "root" device during initial provisioning.  Used to override "default" value (vm_disk).
- var_part (optional) = size of "var" partition (default size is 10240 in baseOS template).  Used for exact size (-L) parameter of lvextend and
                        must be purely numeric without any (unit of measure, unlike the "rt_disk" value)
- iso (optional) = name of file to be available to mount within KVM (only portion of filename before ".iso" is provided, and file MUST exist in /srv/iso folder)
- net2 (optional) = the name of the secondary bridge device to be linked to an additional network connection for the individual KVM
- ip_addr2 (optional) = the static IP address for the additional network connection for the individual KVM

An example of items follows:

  kvm_list:
    - {name: "ipa1",       ip_addr: "192.168.100.40", enabled: true,  roles: ["ipa_host",      "nbde_clients", "logger_client"], cpus: 2, ram_mb: 4096}
    - {name: "foreman",    ip_addr: "192.168.100.44", enabled: true,  roles: ["foreman_host",  "nbde_clients", "ipa_client", "logger_client"], rt_disk: '240G', var_part: 102400, iso: "foreman"}
    - {name: "mirror-reg", ip_addr: "192.168.100.45", enabled: true,  roles: ["registry_host", "nbde_clients", "ipa_client", "logger_client"], rt_disk: '80G'}

Upon launching "./setup.sh <environment name>", user will be prompted for multiple passwords including:
- "SSH password" -- password for "current user" executing the playbook on the server HOSTING all the KVM instances
- "BECOME password" -- usually the same as the value for "SSH password" (will default to that value when simply hitting ENTER w/o any other entry)
- "Vault password" -- used to decrypt the referenced "secrets" file containing values (mainly passwords) for various configured items
    (i.e. IPA/FOREMAN/QUAY admin user, etc.)

The single parameter required to run the setup stipulates the "environment name" for which there need to be corresponding files (with ".yml" extension) in both the hosts and secrets folders.  If the parameter is NOT provided or corresponding files in those two folders not located, the playbook will NOT be executed.

The following items have been configured for deployment to the KVM instances based on the specified "role":

- [x] FreeIPA (role: ipa_host / ipa_client) - Identity Management System providing Identity, Policy, and Audit (IPA) capabilities.
- [x] Quay Mirror Registry (role: registry_host)
- [x] Foreman with Katello (role: foreman_host)
- [ ] ~~Tang (role: nbde_servers) and Clevis (role: nbde_clients) - Disk encryption via LUKS with centralized key repository - TBD~~
- [ ] ~~Vault (role: vault_host) - HashiCorp (role: vault_host)~~
- [x] E-mail Relay
- [ ] ClamAV
- [ ] Backup Server
- [ ] CI/CD Tooling
- [ ] OpenShift - ACS, Compliance Operator, File Integrity Operator

There are additional "playbooks" that can be executed for various operational related tasks.  These files are:

- foreman_host_upstream_incr.yml -- This playbook will connect to an "upstream" Foreman instance, create/publish a NEW version of a Content View, export that new version locally, and copy the generated files/artifact to the "mgmt" server (to /srv/content_view/ sub-folder) all in preparation for "deployment" to a "downstream" Foreman instance.  An example of a command-line to run this play is -- *ansible-playbook -i hosts/sully_upstream.yml foreman_host_upstream_incr.yml -vv -e @./secrets/sully_upstream.yml -e "frmn_content_view_new_version_num=2" --ask-vault-pass --ask-become-pass --ask-pass*.  The *frmn_content_view_new_version_num* variable must be provided a *integer* value (major version) that will be created in Foreman.
- foreman_ost_downstream_incr.yml -- This playbook will connect to a "downstream" Foreman instance, upload the generated files/artifacts to the host, and initiate a Hammer session to import the uploaded files.  An example of a command-line to runs htis play is -- *ansible-playbook -i hosts/sully_downstream.yml foreman_host_downstream_incr.yml -vv -e @./secrets/sully_downstream.yml -e "frmn_import_stg_version_num='2.0' frmn_import_stg_tsfolder='YYYY-MM-DDThh-mm-ss-00-00'" --ask-vault-pass --ask-become-pass --ask-pass*.  The "frmn_import_stg_version_num" variable value must be provided as a *string* representing "<major>.<minor>" version numbers and **MUST** match the folder name generated by the export (i.e. in "/srv/content_view/APE_Content_View/**_2.0_**/2024-09-01T01-00-00-00-00", "2.0" is the generated value).  Similarly, the "frmn_import_stg_tsfolder" variable value must also be provided as a *string* and represents the _timestamp_ when the export was executed (i.e. in the prior example string, the final sub-folder name starting with "2024-09-01" is that value).

