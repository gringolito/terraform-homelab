locals {
  vm_networking = {
    for i, id in proxmox_virtual_environment_vm.cloudinit_vm.network_interface_names :
    id => {
      mac_address    = proxmox_virtual_environment_vm.cloudinit_vm.mac_addresses[i],
      ipv4_addresses = proxmox_virtual_environment_vm.cloudinit_vm.ipv4_addresses[i],
      ipv6_addresses = proxmox_virtual_environment_vm.cloudinit_vm.ipv6_addresses[i]
    } if id != "lo"
  }
  first_interface   = "eth0"
  ip_address        = try(element(local.vm_networking[local.first_interface].ipv4_addresses, 0), null)
  mac_address       = try(lower(local.vm_networking[local.first_interface].mac_address), null)
  ansible_groups    = [for tag in var.tags : replace(tag, "-", "_")]
  default_disk_size = 10
}

resource "proxmox_virtual_environment_file" "cloudinit_config" {
  content_type = "snippets"
  datastore_id = var.ci_storage
  node_name    = var.pve_node

  source_raw {
    data = templatefile("${path.module}/cloud-init/user-config-${var.ci_type}.yaml.tftpl", {
      name                = var.name,
      domain              = var.ci_domain,
      username            = var.ci_username,
      ssh_authorized_keys = var.ci_ssh_public_keys
    })
    file_name = "${var.name}.cloudinit-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "cloudinit_vm" {
  node_name       = var.pve_node
  name            = var.name
  description     = "${var.description}\n\nManaged by Terraform"
  tags            = var.tags
  bios            = var.efi ? "ovmf" : "seabios"
  migrate         = true
  machine         = "q35"
  scsi_hardware   = var.scsi_controller
  on_boot         = var.power_on
  started         = var.power_on
  stop_on_destroy = true

  agent {
    enabled = true
    trim    = true
    timeout = "1m"
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
    import_from  = var.pvi_id
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

    dynamic "ip_config" {
      for_each = tolist(var.networks)
      content {
        ipv4 {
          address = "dhcp"
        }
        ipv6 {
          address = "dhcp"
        }
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloudinit_config.id
  }

  dynamic "network_device" {
    for_each = tolist(var.networks)
    content {
      bridge = network_device.value
      model  = var.nic_model
    }
  }

  dynamic "hostpci" {
    for_each = tolist(var.gpu_passthrough ? [1] : [])
    content {
      device  = "hostpci${hostpci.key}"
      mapping = var.gpu_mapping
      mdev    = var.gpu_mdev_device_type
      pcie    = true
      rombar  = true
      xvga    = false
    }
  }

  dynamic "efi_disk" {
    for_each = tolist(var.efi ? [true] : [])
    content {
      datastore_id      = var.disk_storage
      file_format       = "raw"
      pre_enrolled_keys = true
      type              = "4m"
    }
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    datastore_id = var.disk_storage
    version      = "v2.0"
  }

  serial_device {}

  vga {
    type = var.gpu_passthrough ? "serial0" : "std"
  }

  watchdog {
    enabled = true
    action  = "reset"
  }

  lifecycle {
    ignore_changes = [node_name, disk[0].import_from, disk[0].file_id, initialization]
  }
}

resource "proxmox_virtual_environment_haresource" "cloudinit_vm" {
  resource_id = "vm:${proxmox_virtual_environment_vm.cloudinit_vm.vm_id}"
  state       = var.power_on ? "started" : "disabled"
  comment     = "Managed by Terraform"
}

resource "ansible_host" "cloudinit_vm" {
  name   = var.name
  groups = local.ansible_groups
  variables = {
    ansible_user                 = var.ci_username
    ansible_host                 = local.ip_address
    ansible_ssh_private_key_file = var.ssh_private_key_path
    ansible_ssh_extra_args       = "-o StrictHostKeyChecking=no"
    terraform_var_file           = var.ansible_variables
  }
}

resource "ansible_playbook" "bootstrap" {
  count      = var.ansible_provision ? 1 : 0
  playbook   = var.ansible_playbook
  name       = var.name
  groups     = local.ansible_groups
  extra_vars = ansible_host.cloudinit_vm.variables

  # This script will redirect the out and error to a log file at ./ansible-output-{name}.log
  ansible_playbook_binary = var.ansible_playbook_binary
  replayable              = false

  depends_on = [proxmox_virtual_environment_vm.cloudinit_vm]
  # lifecycle {
  #   replace_triggered_by = [
  #   ]
  # }
}
