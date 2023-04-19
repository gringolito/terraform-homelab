module "el7_cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  template = "centos-7-x64-ci-template"
  ssh_private_key_path = var.ssh_private_key_path
  ci_ssh_public_keys = var.ssh_public_keys
  ci_wait = 90

  for_each = var.el7_vms
  name = each.key
  description = each.value.description
  vcpus = each.value.vcpus
  memory = each.value.memory
  ci_ip = each.value.ip
  ansible_groups = [ "centos_7" ]
}

module "el9_cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  template = "rocky-9-x64-ci-template"
  ssh_private_key_path = var.ssh_private_key_path
  ci_ssh_public_keys = var.ssh_public_keys

  for_each = var.el9_vms
  name = each.key
  description = each.value.description
  vcpus = each.value.vcpus
  memory = each.value.memory
  ci_ip = each.value.ip
}
