locals {
  debian_ci_config = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    hostname: ${var.name}
    fqdn: ${var.name}.${var.ci_domain}
    prefer_fqdn_over_hostname: true
    users:
      - name: ${var.ci_username}
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - ${var.ci_ssh_public_keys}
    packages:
      - qemu-guest-agent
      - vim
      - htop
    runcmd:
      - systemctl enable --now qemu-guest-agent.service
    EOF

  redhat_ci_config = <<-EOF
    #cloud-config
    package_upgrade: true
    hostname: ${var.name}
    fqdn: ${var.name}.${var.ci_domain}
    prefer_fqdn_over_hostname: true
    users:
      - name: ${var.ci_username}
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh_authorized_keys:
          - ${var.ci_ssh_public_keys}
    bootcmd:
      - [ cloud-init-per, once, epel-release, dnf, install, "-y", epel-release ]
    packages:
      - qemu-guest-agent
      - vim
      - htop
    runcmd:
      - systemctl enable --now qemu-guest-agent.service
    EOF

  vm_networking = {
    for i, id in proxmox_virtual_environment_vm.cloudinit_vm.network_interface_names :
    id => {
      mac_address    = proxmox_virtual_environment_vm.cloudinit_vm.mac_addresses[i],
      ipv4_addresses = proxmox_virtual_environment_vm.cloudinit_vm.ipv4_addresses[i],
      ipv6_addresses = proxmox_virtual_environment_vm.cloudinit_vm.ipv6_addresses[i]
    } if id != "lo"
  }
  first_interface   = "eth0"
  ip_address        = element(local.vm_networking[local.first_interface].ipv4_addresses, 0)
  mac_address       = lower(local.vm_networking[local.first_interface].mac_address)
  default_disk_size = 10
}

# Create the Proxmox VM
resource "proxmox_virtual_environment_vm" "cloudinit_vm" {
  node_name     = var.pve_node
  name          = var.name
  description   = "${var.description}\n\nManaged by Terraform"
  tags          = var.tags
  migrate       = true
  machine       = "q35"
  scsi_hardware = var.scsi_controller

  agent {
    enabled = true
  }

  cpu {
    cores = var.vcpus
    type  = "host"
  }

  memory {
    dedicated = var.memory
    floating  = var.memory # set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = var.disk_storage
    file_id      = var.pvi_id
    interface    = "virtio0"
    iothread     = true
    size         = var.disk_size != null ? var.disk_size : local.default_disk_size
  }

  initialization {
    datastore_id = var.disk_storage

    dns {
      domain  = var.ci_domain
      servers = [var.ci_dns_server]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloundinit_config.id
  }

  network_device {
    bridge = var.network_bridge
    model  = var.nic_model
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    datastore_id = var.disk_storage
    version      = "v2.0"
  }

  serial_device {}

  vga {}

  lifecycle {
    ignore_changes = [node_name, disk[0].file_id, initialization, tpm_state]
  }
}

# Generate the cloud-init config file
resource "proxmox_virtual_environment_file" "cloundinit_config" {
  content_type = "snippets"
  datastore_id = var.ci_storage
  node_name    = var.pve_node

  source_raw {
    data      = var.ci_type == "redhat" ? local.redhat_ci_config : local.debian_ci_config
    file_name = "${var.name}.cloudinit-config.yaml"
  }
}

# Create the Ansible inventory host
resource "ansible_host" "cloudinit_vm" {
  name   = var.name
  groups = [for tag in var.tags : replace(tag, "-", "_")]
  variables = {
    ansible_user                 = var.ci_username
    ansible_host                 = local.ip_address
    ansible_ssh_private_key_file = var.ssh_private_key_path
    ansible_ssh_extra_args       = "-o StrictHostKeyChecking=no"
  }
}

# Create the static DHCP lease reservation
resource "dnsmasq_dhcp_static_host" "cloudinit_vm" {
  mac_address = local.mac_address
  ip_address  = local.ip_address
  hostname    = var.name
}
