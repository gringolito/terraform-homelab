locals {
  bootstrap            = false
  incus_profile_memory = local.bootstrap ? "512MiB" : "256MiB"

  ansible_root      = "${path.module}/../ansible"
  ansible_variables = yamldecode(ansible_vault.variables.yaml)
  networks          = nonsensitive(local.ansible_variables.networks)
  containers        = nonsensitive(local.ansible_variables.containers)

  _env = {
    dev = {
      incus_remote       = "incus"
      incus_arch         = "x86_64"
      incus_image        = "ubuntu/noble/cloud"
      incus_storage_pool = "block-storage"
      ansible_variables  = "ansible-variables-dev.yaml"
      delay              = "30s"
    }
    prod = {
      incus_remote       = "nano-pi"
      incus_arch         = "aarch64"
      incus_image        = "ubuntu/noble/cloud/arm64"
      incus_storage_pool = "default"
      ansible_variables  = "ansible-variables-prod.yaml"
      delay              = "600s"
    }
  }
  env          = lookup(local._env, terraform.workspace, "dev")
  incus_remote = local.env.incus_remote
}
