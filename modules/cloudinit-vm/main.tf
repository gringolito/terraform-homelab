locals {
  ssh_private_key = file(var.ssh_private_key_path)
}

resource "proxmox_vm_qemu" "cloudinit_vm" {
  target_node = "pve01"
  agent       = 1

  name  = var.name
  desc  = var.description
  clone = var.template

  cores  = var.vcpus
  memory = var.memory
  scsihw = var.scsi_controller

  network {
    bridge = "vmbr0"
    model  = var.nic_model
  }

  # disk {
  #   storage  = "local-lvm"
  #   type     = "virtio"
  #   size     = "20G"
  #   iothread = true
  # }

  os_type      = "cloud-init"
  ipconfig0    = "ip=${var.ci_ip}/${var.ci_netmask},gw=${var.ci_gateway}"
  nameserver   = var.ci_dns_server
  searchdomain = var.ci_domain
  ciuser       = var.ci_username
  cipassword   = var.ci_password
  sshkeys      = var.ci_ssh_public_keys
  ci_wait      = var.ci_wait

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = var.ci_ip
      user        = var.ci_username
      private_key = file(var.ssh_private_key_path)
    }

    inline = [
      "/usr/sbin/ip addr show"
    ]
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ci_username} -i '${var.ci_ip},' --private-key ${var.ssh_private_key_path} ansible/playbook.yml"
  }
}

resource "ansible_host" "cloudinit_vm" {
  name      = var.name
  groups    = var.ansible_groups
  variables = var.ansible_custom_vars
}
