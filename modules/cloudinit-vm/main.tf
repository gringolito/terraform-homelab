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
  vga {
    type = "std"
  }

  network {
    bridge = "vmbr0"
    model  = var.nic_model
  }

  disk {
    storage = "local-lvm"
    type    = "cloudinit"
    slot    = "ide0"
    backup  = false
    format  = null
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
  #     ansible-playbook \
  #       -i ansible/inventory.yaml \
  #       --limit '${var.ci_ip},' \
  #       ansible/playbook.yaml
  #   EOF
  # }
}

resource "ansible_host" "cloudinit_vm" {
  name   = var.name
  groups = [for tag in var.tags : replace(tag, "-", "_")]
  variables = {
    ansible_user                 = var.ci_username
    ansible_host                 = var.ci_ip
    ansible_ssh_private_key_file = var.ssh_private_key_path
    ansible_ssh_extra_args       = "-o StrictHostKeyChecking=no"
  }
}
