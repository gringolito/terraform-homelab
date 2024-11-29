output "mac-address" {
  value = proxmox_vm_qemu.cloudinit_vm.network[0].macaddr
}

output "ip-address" {
  value = proxmox_vm_qemu.cloudinit_vm.default_ipv4_address
}

output "cpus" {
  value = proxmox_vm_qemu.cloudinit_vm.cores
}

output "memory" {
  value = proxmox_vm_qemu.cloudinit_vm.memory
}

output "tags" {
  value = proxmox_vm_qemu.cloudinit_vm.tags
}

output "ansible-groups" {
  value = join(" ", ansible_host.cloudinit_vm.groups)
}
