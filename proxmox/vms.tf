module "cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  ssh_private_key_path    = var.ssh_private_key_path
  ci_ssh_public_keys      = var.ssh_public_keys
  pve_node                = var.proxmox_node
  disk_storage            = var.vm_storage
  ci_storage              = var.cloudinit_storage
  ci_domain               = local.cluster_dns_domain
  ci_dns_server           = local.dns_server
  gpu_mapping             = local.intel_gpu_mapping.name
  gpu_mdev_device_type    = local.intel_gpu_mapping.mdev
  ansible_playbook_binary = local.ansible_playbook_binary
  ansible_playbook        = local.ansible_playbook
  ansible_variables       = "../proxmox/configuration/ansible-variables.yaml"

  for_each          = var.vms
  name              = each.key
  description       = each.value.description
  vcpus             = each.value.vcpus
  memory            = each.value.memory
  networks          = each.value.networks
  disk_size         = each.value.disk_size
  pvi_id            = lookup(proxmox_virtual_environment_download_file.pvi, each.value.pvi).id
  ci_type           = lookup(local.pvi_images, each.value.pvi).ci-type
  tags              = concat([each.value.pvi], each.value.tags)
  power_on          = each.value.power_on
  gpu_passthrough   = each.value.gpu_passthrough
  ansible_provision = each.value.provision
}

resource "proxmox_virtual_environment_vm" "appliances" {
  for_each      = var.appliances
  node_name     = var.proxmox_node
  name          = each.key
  bios          = each.value.efi ? "ovmf" : "seabios"
  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  on_boot       = each.value.power_on
  started       = each.value.power_on

  agent {
    enabled = true
    trim    = true
  }

  cpu {
    cores = each.value.vcpus
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory # set equal to dedicated to enable ballooning
  }

  dynamic "disk" {
    for_each = tolist(each.value.disks)

    content {
      datastore_id = var.vm_storage
      iothread     = true
      interface    = "${each.value.disk_interface}${disk.key}"
      size         = disk.value
    }
  }

  dynamic "network_device" {
    for_each = tolist(each.value.networks)
    content {
      bridge = network_device.value
      model  = "virtio"
    }
  }

  dynamic "hostpci" {
    for_each = tolist(each.value.gpu_passthrough ? [local.intel_gpu_mapping] : [])
    content {
      device  = "hostpci${hostpci.key}"
      mapping = hostpci.value.name
      mdev    = hostpci.value.mdev
      pcie    = true
      rombar  = true
      xvga    = false
    }
  }

  dynamic "efi_disk" {
    for_each = tolist(each.value.efi ? [true] : [])
    content {
      datastore_id      = var.vm_storage
      file_format       = "raw"
      pre_enrolled_keys = true
      type              = "4m"
    }
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    datastore_id = var.vm_storage
    version      = "v2.0"
  }

  serial_device {}

  vga {
    type = each.value.gpu_passthrough ? "serial0" : "std"
  }

  lifecycle {
    ignore_changes = [node_name, initialization, tpm_state, mac_addresses, migrate, disk]
  }
}


resource "proxmox_virtual_environment_vm" "desktops" {
  for_each      = var.desktops
  node_name     = var.proxmox_node
  name          = each.key
  bios          = each.value.efi ? "ovmf" : "seabios"
  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"
  on_boot       = each.value.power_on
  started       = each.value.power_on

  agent {
    enabled = true
    trim    = true
  }

  cpu {
    cores = each.value.vcpus
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
    floating  = each.value.memory # set equal to dedicated to enable ballooning
  }

  dynamic "disk" {
    for_each = tolist(each.value.disks)

    content {
      datastore_id = var.vm_storage
      iothread     = true
      interface    = "${each.value.disk_interface}${disk.key}"
      size         = disk.value
    }
  }

  dynamic "network_device" {
    for_each = tolist(each.value.networks)
    content {
      bridge = network_device.value
      model  = "virtio"
    }
  }

  dynamic "hostpci" {
    for_each = tolist(each.value.gpu_passthrough ? [local.intel_gpu_mapping] : [])
    content {
      device  = "hostpci${hostpci.key}"
      mapping = hostpci.value.name
      mdev    = hostpci.value.mdev
      pcie    = true
      rombar  = true
      xvga    = false
    }
  }

  dynamic "efi_disk" {
    for_each = tolist(each.value.efi ? [true] : [])
    content {
      datastore_id      = var.vm_storage
      file_format       = "raw"
      pre_enrolled_keys = true
      type              = "4m"
    }
  }

  operating_system {
    type = each.value.os
  }

  tpm_state {
    datastore_id = var.vm_storage
    version      = "v2.0"
  }

  vga {
    type = "virtio-gl"
  }

  lifecycle {
    ignore_changes = [node_name, initialization, tpm_state, mac_addresses, migrate, efi_disk, disk]
  }
}
