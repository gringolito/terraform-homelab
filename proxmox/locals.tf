locals {
  ansible_root            = "${path.module}/../ansible"
  ansible_playbook_binary = "${local.ansible_root}/bin/tf-ansible-playbook"
  ansible_playbook        = "${local.ansible_root}/vms.yaml"

  vault                  = nonsensitive(yamldecode(ansible_vault.terraform_variables.yaml))
  dns_server             = local.vault.dns_server
  cluster_dns_domain     = local.vault.cluster_dns_domain
  cluster_migration_cidr = local.vault.cluster_migration_cidr
  intel_gpu_mapping      = local.vault.intel_gpu_mapping

  bridges = {
    for item in flatten([
      for name, bridge in local.vault.pve_bridges : [
        for node, config in bridge.nodes : {
          key     = "${node}/${name}"
          name    = name
          comment = bridge.comment
          node    = node
          config  = config
        }
      ]
    ]) : item.key => item
  }

  vlans = {
    for item in flatten([
      for name, vlan in local.vault.pve_vlans : [
        for node, config in vlan.nodes : {
          key     = "${node}/${name}"
          name    = name
          comment = vlan.comment
          vlan_id = vlan.vlan_id
          node    = node
          config  = config
        }
      ]
    ]) : item.key => item
  }

  sdn_vlan_zones = local.vault.pve_sdn_vlan_zones
  snd_vlan_zones_vnets = {
    for item in flatten([
      for zone, config in local.vault.pve_sdn_vlan_zones : [
        for vnet, vlan_id in config.vnets : {
          key     = "${zone}/${vnet}"
          zone    = zone
          vnet    = vnet
          vlan_id = vlan_id
        }
      ]
    ]) : item.key => item
  }

  pvi_images = {
    debian-12 = {
      url      = "https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
      filename = "debian-12-genericcloud-amd64.qcow2"
      ci-type  = "debian"
    }
    debian-13 = {
      url      = "https://cdimage.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
      filename = "debian-13-genericcloud-amd64.qcow2"
      ci-type  = "debian"
    }
    ubuntu-22 = {
      url      = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
      filename = "ubuntu-server-22.04-lts-cloudimg-amd64.qcow2"
      ci-type  = "debian"
    }
    ubuntu-24 = {
      url      = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
      filename = "ubuntu-server-24.04-lts-cloudimg-amd64.qcow2"
      ci-type  = "debian"
    }
    rocky-8 = {
      url = "https://plug-mirror.rcac.purdue.edu/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2"
      # url      = "https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2"
      filename = "rocky-8-genericcloud-amd64.qcow2"
      ci-type  = "redhat"
    }
    rocky-9 = {
      url      = "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
      filename = "rocky-9-genericcloud-amd64.qcow2"
      ci-type  = "redhat"
    }
    rocky-10 = {
      url      = "https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
      filename = "rocky-10-genericcloud-amd64.qcow2"
      ci-type  = "redhat"
    }
    almalinux-8 = {
      url = "https://mirror.uepg.br/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2"
      # url      = "https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2"
      filename = "almalinux-8-genericcloud-amd64.qcow2"
      ci-type  = "redhat"
    }
    almalinux-9 = {
      url      = "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
      filename = "almalinux-9-genericcloud-amd64.qcow2"
      ci-type  = "redhat"
    }
    almalinux-10 = {
      url      = "https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-latest.x86_64.qcow2"
      filename = "almalinux-10-genericcloud-amd64.qcow2"
      ci-type  = "redhat"
    }
    oraclelinux-10 = {
      url      = "https://yum.oracle.com/templates/OracleLinux/OL10/u0/x86_64/OL10U0_x86_64-kvm-b266.qcow2"
      filename = "oraclelinux-10-kvm-amd64.qcow2"
      ci-type  = "redhat"
    }
  }
}
