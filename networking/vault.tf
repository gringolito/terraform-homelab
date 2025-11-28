resource "ansible_vault" "variables" {
  vault_file          = "${path.module}/configurations/${local.env.ansible_variables}"
  vault_password_file = var.ansible_vault_password_file
  vault_id            = "homelab"
}
