module "deb11_cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  template = "debian-11-x64-ci-template"
  ssh_private_key_path = var.ssh_private_key_path
  ci_ssh_public_keys = var.ssh_public_keys

  for_each = var.deb11_vms
  # name = "${each.key}.deb11"
  name = each.key
  description = each.value.description
  vcpus = each.value.vcpus
  memory = each.value.memory
  ci_ip = each.value.ip
  tags = each.value.extra_tags != null ? concat(["deb11"], each.value.extra_tags) : ["deb11"]
}

module "deb12_cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  template = "debian-12-x64-ci-template"
  ssh_private_key_path = var.ssh_private_key_path
  ci_ssh_public_keys = var.ssh_public_keys

  for_each = var.deb12_vms
  # name = "${each.key}.deb12"
  name = each.key
  description = each.value.description
  vcpus = each.value.vcpus
  memory = each.value.memory
  ci_ip = each.value.ip
  tags = each.value.extra_tags != null ? concat(["deb12"], each.value.extra_tags) : ["deb12"]
}

module "el8_cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  template = "rocky-8-x64-ci-template"
  ssh_private_key_path = var.ssh_private_key_path
  ci_ssh_public_keys = var.ssh_public_keys

  for_each = var.el8_vms
  # name = "${each.key}.el8"
  name = each.key
  description = each.value.description
  vcpus = each.value.vcpus
  memory = each.value.memory
  ci_ip = each.value.ip
  tags = each.value.extra_tags != null ? concat(["el8"], each.value.extra_tags) : ["el8"]
}

module "el9_cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  template = "rocky-9-x64-ci-template"
  ssh_private_key_path = var.ssh_private_key_path
  ci_ssh_public_keys = var.ssh_public_keys

  for_each = var.el9_vms
  # name = "${each.key}.el9"
  name = each.key
  description = each.value.description
  vcpus = each.value.vcpus
  memory = each.value.memory
  ci_ip = each.value.ip
  tags = each.value.extra_tags != null ? concat(["el9"], each.value.extra_tags) : ["el9"]
}

module "ubuntu22_cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  template = "ubuntu-22.04-x64-ci-template"
  ssh_private_key_path = var.ssh_private_key_path
  ci_ssh_public_keys = var.ssh_public_keys

  for_each = var.ubuntu22_vms
  # name = "${each.key}.ubuntu22"
  name = each.key
  description = each.value.description
  vcpus = each.value.vcpus
  memory = each.value.memory
  ci_ip = each.value.ip
  tags = each.value.extra_tags != null ? concat(["ubuntu22"], each.value.extra_tags) : ["ubuntu22"]
}

module "ubuntu24_cloudinit_vms" {
  source = "./modules/cloudinit-vm"

  template = "ubuntu-24.04-x64-ci-template"
  ssh_private_key_path = var.ssh_private_key_path
  ci_ssh_public_keys = var.ssh_public_keys

  for_each = var.ubuntu24_vms
  # name = "${each.key}.ubuntu24"
  name = each.key
  description = each.value.description
  vcpus = each.value.vcpus
  memory = each.value.memory
  ci_ip = each.value.ip
  tags = each.value.extra_tags != null ? concat(["ubuntu24"], each.value.extra_tags) : ["ubuntu24"]
}
