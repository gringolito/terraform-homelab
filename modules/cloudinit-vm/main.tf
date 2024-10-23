resource "proxmox_vm_qemu" "cloudinit_vm" {
  target_node = "Lenovo-M920q-01"
  agent       = 1
  onboot      = true
  pool        = ""

  hastate = "started"
  hagroup = var.hagroup

  name  = var.name
  desc  = var.description
  tags  = join(";", concat(["cloud-init"], var.tags))
  clone = var.template

  cores  = var.vcpus
  memory = var.memory
  scsihw = var.scsi_controller

  network {
    bridge = "vmbr0"
    model  = var.nic_model
  }

  disk {
    storage = "local-lvm"
    type    = "cloudinit"
    slot    = "ide0"
  }

  disk {
    storage   = "truenas-vm-disks"
    type      = "disk"
    slot      = "virtio0"
    size      = "20G"
    replicate = true
  }

  os_type      = "cloud-init"
  ipconfig0    = "ip=${var.ci_ip}/${var.ci_netmask},gw=${var.ci_gateway},ip6=dhcp"
  nameserver   = var.ci_dns_server
  searchdomain = var.ci_domain
  ciuser       = var.ci_username
  cipassword   = var.ci_password
  ciupgrade    = true
  sshkeys      = var.ci_ssh_public_keys
  ci_wait      = var.ci_wait

  # automatic_reboot = true

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

  # provisioner "local-exec" {
  #   command = <<-EOF
  #     ANSIBLE_HOST_KEY_CHECKING=False \
  #     ansible-playbook \
  #       -u ${var.ci_username} \
  #       -i ansible/inventory.ini \
  #       --limit '${var.ci_ip},' \
  #       --private-key ${var.ssh_private_key_path} \
  #       ansible/playbook.yaml
  #   EOF
  # }
}

resource "ansible_host" "cloudinit_vm" {
  name   = proxmox_vm_qemu.cloudinit_vm.name
  groups = proxmox_vm_qemu.cloudinit_vm.tags
  variables = {
    ansible_user                 = proxmox_vm_qemu.cloudinit_vm.ci_username,
    ansible_ssh_private_key_file = proxmox_vm_qemu.cloudinit_vm.ssh_private_key_path
    ansible_ssh_extra_args       = "-o StrictHostKeyChecking=no"
  }
}
