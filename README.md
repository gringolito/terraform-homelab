# HomeLab IaC

Infrastructure-as-Code for my fully automated homelab setup. This repository couples Terraform
stacks with Ansible roles/playbooks to provision and configure virtualization, networking, storage,
DNS, Kubernetes, and core services end‑to‑end.

## High-Level Architecture

- Terraform projects are split into focused stacks (`networking/`, `vms/`, `dns/`, `minio-backend/`) to allow iterative, isolated applies.
- Remote state is stored in a MinIO S3 bucket (bootstrapped by the `minio-backend/` Terraform project).
- Secrets and sensitive variables are managed with Vault integration and `ansible-vault` encrypted files. (vaulted config YAMLs).
- Configuration management and service setup are handled via Ansible (`ansible/`).

### Components

- Virtualization: Proxmox VMs (`vms/`) and Incus containers (`networking/`).
- Network Services: ISC Kea DHCP, radvd (IPv6 RA), Unbound (recursive DNS), PowerDNS (authoritative), Pi-hole (blocking).
- Kubernetes: Cluster provisioning & configuration via Ansible role (`ansible/roles/kubernetes`).
- DNS Orchestration: Dynamic zone updates through Terraform `dns/` stack using TSIG.
- Object Storage / State: MinIO S3 bucket (`minio-backend/`) hosting Terraform state.
- Cloud-Init: Templated instance metadata in `networking/cloud-init/` and `vms/modules/cloudinit-vm/`.
- Configuration Data: Environment‑specific YAML overlays under `networking/configurations/` and `dns/configurations/`.

### Providers Used

- `ansible/ansible` for invoking playbooks during/after provisioning and Vault integration
- `bpg/proxmox` for VM lifecycle
- `hashicorp/aws` (pointed at MinIO) for S3-compatible remote state bucket
- `hashicorp/cloudinit` for instance bootstrap metadata
- `hashicorp/dns` for record management
- `lxc/incus` for LXC container orchestration

## Directory Overview

```text
ansible/          Inventory, group vars, roles (DHCP, DNS, K8s, etc.)
networking/       Incus containers for base network services (DHCP & DNS)
vms/              Proxmox virtual machines (module: cloudinit-vm)
dns/              Authoritative DNS record management via Terraform
minio-backend/    S3 bucket for shared Terraform remote state
```

## Bootstrapping / Disaster Recovery

1. Bootstrap remote state (`minio-backend/`): create S3 bucket.
1. Apply networking stack: provision Incus containers + base network services.
1. Apply DNS stack: populate zones/records for statically managed IPs.
1. Apply VM stack: create Proxmox VMs with cloud-init.
1. Run Ansible playbook: configure services & Kubernetes cluster.

## Secrets & Security

- TSIG keys for DNS updates passed via variables.
- Ansible secrets encrypted with `ansible-vault` (see inventory & vaulted YAML examples).

## Future Enhancements

- CI pipeline for plan/apply validation.
