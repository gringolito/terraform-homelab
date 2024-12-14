output "ipv4-address" {
  value       = [for ip in local.vm_networking[local.first_interface].ipv4_addresses : ip]
  description = "IPv4 addresses for the eth0 interface"
}

output "ipv6-address" {
  value       = [for ip in local.vm_networking[local.first_interface].ipv6_addresses : ip]
  description = "IPv6 addresses for the eth0 interface"
}

output "mac-address" {
  value       = local.mac_address
  description = "MAC address for the eth0 interface"
}

output "vm-networking" {
  value       = local.vm_networking
  description = "Full networking configuration"
}
