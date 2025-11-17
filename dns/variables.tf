variable "ansible_vault_password_file" {
  description = "Path to the ansible-vault password file used to decrypt encrypted variables and playbook content during provisioning."
  type        = string
}

variable "nameserver_address" {
  description = "Authoritative DNS server address (IP or FQDN) receiving dynamic updates via TSIG."
  type        = string
}

variable "tsig_key_name" {
  description = "TSIG key name used to authenticate dynamic DNS updates."
  type        = string
}

variable "tsig_key_algorithm" {
  description = "TSIG key algorithm (e.g. hmac-sha256) matching server configuration."
  type        = string
}

variable "tsig_key_secret" {
  description = "TSIG key secret (base64) used to sign DNS update requests."
  type        = string
  sensitive   = true
}
