variable "name" {
  description = "VM hostname"
  type        = string
}

variable "description" {
  description = "Human-readable description to be added on the VM metadata"
  type        = string
}

variable "tags" {
  description = "List of tags to be added on the VM"
  type        = list(string)
  default     = []
}

variable "pvi_id" {
  description = "The Proxmox VM Image (PVI) ID to create the VM from"
  type        = string
}

variable "vcpus" {
  description = "The number of CPU cores to be assigned to the VM"
  type        = number
  default     = 1
}

variable "memory" {
  description = "The VM RAM memory size in MB"
  type        = number
  default     = 1024
}

variable "disk_size" {
  description = "The VM disk size in GB"
  type        = number
  default     = 10
}

variable "disk_storage" {
  description = "Storage pool or volume where the VM disk will be created (e.g. local-lvm, nfs-storage)"
  type        = string
}

variable "pve_node" {
  description = "Proxmox node to assign the VM to"
  type        = string
}

variable "networks" {
  description = "List of network bridge names on the Proxmox host to attach the VM NIC(s) to"
  type        = list(string)
  default     = []
}

variable "power_on" {
  description = "Whether the VM should be powered on or not"
  type        = bool
  default     = true
}

variable "scsi_controller" {
  description = "SCSI controller model to attach to the VM"
  type        = string
  default     = "virtio-scsi-pci"
}

variable "nic_model" {
  description = "Virtual NIC model presented to the VM (e.g. virtio, e1000)"
  type        = string
  default     = "virtio"
}

variable "gpu_passthrough" {
  description = "Whether to enable GPU passthrough for this VM"
  type        = bool
  default     = false
}

variable "gpu_mapping" {
  description = "Logical name or label used to map the GPU resource for passthrough"
  type        = string
  default     = ""
}

variable "gpu_mdev_device_type" {
  description = "Mediated device (mdev) type to use when assigning shared GPU instances"
  type        = string
  default     = ""
}

variable "ci_storage" {
  description = "Storage location to place cloud-init seed/iso or config (e.g. local, local-lvm)"
  type        = string
}

variable "ci_username" {
  description = "Default user created by cloud-init on first boot"
  type        = string
  default     = "ansible"
}

variable "ci_ssh_public_keys" {
  description = "SSH public key(s) injected via cloud-init for the default user (newline-separated)"
  type        = string
}

variable "ci_dns_server" {
  description = "DNS server IP address to configure inside the VM via cloud-init"
  type        = string
  default     = "1.1.1.1"
}

variable "ci_domain" {
  description = "Domain name to configure for the VM's hostname in cloud-init"
  type        = string
}

variable "ci_type" {
  description = "Type of cloud-init configuration type (redhat or debian)"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key used to connect to the VM with Ansible"
  type        = string
}

variable "ansible_provision" {
  description = "Wether to run an Ansible playbook to provision the (newly) created VMs"
  type        = bool
  default     = true
}

variable "ansible_playbook" {
  description = "Path to the Ansible playbook to execute right after launching the VM for the first time"
  type        = string
}

variable "ansible_variables" {
  description = "Path to the Ansible variables file to be applied to this VM"
  type        = string
}

variable "ansible_playbook_binary" {
  description = "Path to the `ansible-playbook` executable binary"
  type        = string
}

variable "efi" {
  description = "Whether the VM boots from a EFI or BIOS (default)"
  type        = bool
  default     = false
}
