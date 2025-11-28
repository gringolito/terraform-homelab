output "ipv4-address" {
  value = { for name, vm in module.cloudinit_vms : name => vm.ipv4-address }
}

output "ipv6-address" {
  value = { for name, vm in module.cloudinit_vms : name => vm.ipv6-address }
}

output "mac-address" {
  value = { for name, vm in module.cloudinit_vms : name => vm.mac-address }
}
