output "mac_address" {
#   value = proxmox_vm_qemu.*.network.eth0.macaddr
  value = [ "${proxmox_vm_qemu.cloudinit_vm.network[0].macaddr}" ]
}

output "ip_address" {
#   value = proxmox_vm_qemu.*.default_ipv4_address
  value = [ "${proxmox_vm_qemu.cloudinit_vm.*.default_ipv4_address}" ]
}
