resource "proxmox_virtual_environment_cluster_options" "options" {
  language                  = "en"
  keyboard                  = "en-us"
  crs_ha                    = "basic"
  crs_ha_rebalance_on_start = true
  ha_shutdown_policy        = "migrate"
  migration_cidr            = local.cluster_migration_cidr
  migration_type            = "secure"
  notify = {
    package_updates        = "always"
    package_updates_target = "default-matcher"
  }
}

resource "proxmox_virtual_environment_time" "timezone" {
  for_each  = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
  node_name = each.key
  time_zone = "America/Sao_Paulo"
}

resource "proxmox_virtual_environment_dns" "unbound" {
  for_each  = toset(data.proxmox_virtual_environment_nodes.available_nodes.names)
  node_name = each.key
  domain    = local.cluster_dns_domain
  servers   = [local.dns_server]
}

resource "proxmox_virtual_environment_hardware_mapping_pci" "intel_gpu" {
  name             = local.intel_gpu_mapping.name
  map              = local.intel_gpu_mapping.map
  mediated_devices = true
}
