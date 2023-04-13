variable "ci_username" {
  default = "ansible"
  type    = string
}

variable "ci_password" {
  default   = null
  type      = string
  sensitive = true
  nullable  = true
}

variable "ci_ssh_private_key_path" {
  type      = string
  sensitive = true
}

variable "ci_ssh_public_keys" {
  type = string
}

variable "ci_dns_server" {
  default = "192.168.11.53"
  type    = string
}

variable "ci_domain" {
  default = "home"
  type    = string
}
