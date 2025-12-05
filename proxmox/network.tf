resource "proxmox_virtual_environment_network_linux_bridge" "bridges" {
  for_each  = local.bridges
  node_name = each.value.node

  name       = each.value.name
  address    = each.value.config.ip_address
  gateway    = each.value.config.gateway
  ports      = each.value.config.interfaces
  vlan_aware = false
  comment    = each.value.comment
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlans" {
  for_each  = local.vlans
  node_name = each.value.node

  name      = "${each.value.config.interface}.${each.value.vlan_id}"
  interface = each.value.config.interface
  address   = each.value.config.ip_address
  comment   = each.value.comment
}

resource "proxmox_virtual_environment_sdn_zone_vlan" "vlan_zones" {
  for_each = local.sdn_vlan_zones
  id       = each.key
  bridge   = each.value.bridge
  mtu      = 1500
}

resource "proxmox_virtual_environment_sdn_vnet" "vlan_vnets" {
  for_each   = local.snd_vlan_zones_vnets
  id         = each.value.vnet
  zone       = each.value.zone
  tag        = each.value.vlan_id
  vlan_aware = false
}
