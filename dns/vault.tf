resource "ansible_vault" "dns_config" {
  vault_file          = "${path.module}/configurations/dns-config.yaml"
  vault_password_file = var.ansible_vault_password_file
  vault_id            = "homelab"
}
