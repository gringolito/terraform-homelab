variable "el7_vms" {
  description = "EL7-compatible VMs"
  default     = {}
  type        = map(any)
}

resource "proxmox_vm_qemu" "el7_ci_vm" {
  for_each    = var.el7_vms
  name        = "el7-${each.key}"
  desc        = each.value.description
  target_node = "pve01"
  clone       = "centos-7-x64-ci-template"

  agent = 1

  cores  = each.value.vcpus
  memory = each.value.memory

  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # disk {
  #   storage  = "local-lvm"
  #   type     = "virtio"
  #   size     = "20G"
  #   iothread = true
  # }

  os_type      = "cloud-init"
  ipconfig0    = "ip=${each.value.ip}/24,gw=192.168.11.1"
  nameserver   = var.ci_dns_server
  searchdomain = var.ci_domain
  ciuser       = var.ci_username
  cipassword   = var.ci_password
  sshkeys      = var.ci_ssh_public_keys
  ci_wait      = 90

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = each.value.ip
      user        = var.ci_username
      private_key = file(var.ci_ssh_private_key_path)
    }

    inline = [
      "/usr/sbin/ip addr show"
    ]
  }

  # provisioner "local-exec" {
  #   # Provisioner commands can be run here.
  #   # We will use provisioner functionality to kick off ansible
  #   # playbooks in the future
  #   command = "touch /home/tcude/test.txt"
  # }

}
