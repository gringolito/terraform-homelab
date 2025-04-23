resource "proxmox_virtual_environment_download_file" "pvi" {
  for_each     = var.pvi_images
  content_type = "iso"
  datastore_id = var.pvi_storage
  node_name    = var.proxmox_node
  url          = each.value.url
  file_name    = each.value.filename
  overwrite    = true
}

resource "proxmox_virtual_environment_hagroup" "terraform" {
  group = "terraform-ha-group"

  nodes = {
    "Beelink-U95-01"  = 1
    "Lenovo-M920q-02" = 2
    "Lenovo-M920q-01" = 3
  }

  no_failback = true
}

module "cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  ssh_private_key_path = var.ssh_private_key_path
  ci_ssh_public_keys   = var.ssh_public_keys
  pve_node             = var.proxmox_node
  disk_storage         = var.vm_storage
  ci_storage           = var.cloudinit_storage

  for_each       = var.vms
  name           = each.key
  description    = each.value.description
  vcpus          = each.value.vcpus
  memory         = each.value.memory
  network_bridge = each.value.network
  disk_size      = each.value.disk_size
  pvi_id         = lookup(proxmox_virtual_environment_download_file.pvi, each.value.pvi).id
  ci_type        = lookup(var.pvi_images, each.value.pvi).ci-type
  tags           = each.value.tags != null ? concat([each.value.pvi], each.value.tags) : [each.value.pvi]
}
