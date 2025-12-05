data "proxmox_virtual_environment_nodes" "available_nodes" {}

resource "ansible_vault" "terraform_variables" {
  vault_file          = "${path.module}/configuration/terraform-variables.yaml"
  vault_password_file = var.vault_password_file
}
