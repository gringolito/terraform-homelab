resource "incus_image" "ubuntu_lts" {
  remote = local.incus_remote
  source_image = {
    remote       = "images"
    name         = local.env.incus_image
    type         = "container"
    architecture = local.env.incus_arch
  }
}

resource "incus_network" "vlans" {
  remote = local.incus_remote

  for_each = local.networks
  name     = each.key
  type     = "bridge"

  config = {
    "bridge.driver"              = "native"
    "bridge.external_interfaces" = each.value.external_interface
    "dns.mode"                   = "none"
    # "ipv4.address"               = "none"
    # "ipv6.address"               = "none"
  }
}

resource "incus_profile" "cloud_init" {
  remote = local.incus_remote

  name = "cloud-init"
  config = {
    "boot.autostart"          = true
    "limits.cpu"              = 2
    "limits.memory"           = local.incus_profile_memory
    "security.guestapi"       = true
    "security.privileged"     = true
    "security.nesting"        = true
    "security.idmap.isolated" = true
    "cloud-init.vendor-data"  = file("${path.module}/cloud-init/vendor-config.yaml")
  }

  device {
    type = "disk"
    name = "root"

    properties = {
      size = "4GiB"
      pool = local.env.incus_storage_pool
      path = "/"
    }
  }
}

resource "incus_instance" "container" {
  remote = local.incus_remote

  for_each = local.containers
  name     = each.key
  type     = "container"
  image    = incus_image.ubuntu_lts.fingerprint
  profiles = [incus_profile.cloud_init.name]
  config = merge({
    "cloud-init.network-config" = templatefile("${path.module}/cloud-init/network-config.yaml.tftpl", { networks = each.value.networks })
    "cloud-init.user-data" = templatefile("${path.module}/cloud-init/user-config.yaml.tftpl", {
      hostname = each.key,
      domain   = each.value.domain,
    })
    },
    try(each.value.config, {})
  )

  dynamic "device" {
    for_each = each.value.networks
    content {
      type = "nic"
      name = device.value.interface

      properties = {
        network = device.key
      }
    }
  }

  wait_for {
    type = "ipv4"
  }
  wait_for {
    type  = "delay"
    delay = local.env.delay
  }
}

resource "ansible_host" "incus" {
  for_each = local.containers
  name     = each.key
  groups   = try(each.value.ansible_groups, [])

  variables = {
    ansible_connection   = "community.general.incus"
    ansible_incus_remote = local.incus_remote
    ansible_user         = "root"
    ansible_become       = false
    terraform_var_file   = "../networking/configurations/${local.env.ansible_variables}"
  }
}

resource "ansible_playbook" "bootstrap" {
  for_each   = ansible_host.incus
  playbook   = "${local.ansible_root}/networking.yaml"
  name       = each.value.name
  groups     = each.value.groups
  extra_vars = each.value.variables

  # This script will redirect the out and error to a log file at ./ansible-output-{name}.log
  ansible_playbook_binary = "${local.ansible_root}/bin/tf-ansible-playbook"
  replayable              = false

  depends_on = [incus_instance.container]
  lifecycle {
    replace_triggered_by = [
      incus_instance.container[each.key],
    ]
  }
}
