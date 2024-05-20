Run the setup script and it will install all required components. 
The network is set up for NAT so might need to update some stuff in the future

The following "roles" have been defined within the playbook configuration for use when deploying any KVM instance.  A KVM is currently defined within the 'kvm_list' variable consisting of 1 or more items (KVMs).  Each item is actually an object defined with the following properties:

- name = the unique short-name for the host within the environment.  Concatenated with the overall 'dns_name' value to produce a fully qualified domain name that will be registered within the IPA component and, temporarily, included within the consolidate 'hosts' file.
- ip_addr = the IP address assigned to the host during provisioning and included in both 'hosts' file and IPA registered host.
- roles = array of host specific roles to determine what add'l components to deploy onto said host.
- cpus (optional) = number of vCPUs allocated to host during initial provisioning.  Used to override "default" value (vm_vcpus).
- ram_mb (optional) = amount of RAM/memory (in MB) to allocate to host during initial provisioning.  Used to override "default" value (vm_ram_mb).
- rt_disk (optional) = amount of disk space to allocate to host for "root" device during initial provisioning.  Used to override "default" value (vm_disk).

An example of items follows:

  kvm_list:
    - {name: "ipa1",       ip_addr: "192.168.100.40", enabled: true,  roles: ["ipa_host",      "nbde_clients", "logger_client"], cpus: 2, ram_mb: 4096}
    - {name: "foreman",    ip_addr: "192.168.100.44", enabled: true,  roles: ["foreman_host",  "nbde_clients", "ipa_client", "logger_client"]}
    - {name: "mirror-reg", ip_addr: "192.168.100.45", enabled: true,  roles: ["registry_host", "nbde_clients", "ipa_client", "logger_client"], rt_disk: '80G'}

Upon launching "./setup.sh", user will be prompted for multiple passwords including:
- "SSH password" -- password for "current user" executing the playbook on the server HOSTING all the KVM instances
- "BECOME password" -- usually the same as the value for "SSH password" (will default to that value when simply hitting ENTER w/o any other entry)
- "Vault password" -- used to decrypt the referenced "secrets" file containing values (mainly passwords) for various configured items
    (i.e. IPA admin user, QUAY admin user, etc.)

The following items have been configured for deployment to the KVM instances based on the specified "role":

- [x] FreeIPA (role: ipa_host / ipa_client) - Identity Management System providing Identity, Policy, and Audit (IPA) capabilities.
- [x] Quay Mirror Registr (role: registry_host)
- [ ] Foreman with Katello (role: foreman_host)
- [ ] Tang (role: nbde_servers) and Clevis (role: nbde_clients) - Disk encryption via LUKS with centralized key repository - TBD
- [ ] Vault (role: vault_host) - HashiCorp - TBD
- [ ] E-mail Relay
- [ ] ClamAV
- [ ] Backup Server
- [ ] CI/CD Tooling
- [ ] OpenShift - ACS, Compliance Operator, File Integrity Operator

