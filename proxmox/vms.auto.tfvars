vms = {
  kube-master-01 = { pvi = "rocky-9", description = "Kubernetes cluster control-plane node 1", vcpus = 3, memory = 4096, disk_size = 20, networks = ["vmbr0"], tags = ["k8s", "k8s-master"], provision = false },
  kube-worker-01 = { pvi = "rocky-9", description = "Kubernetes cluster worker node 1", vcpus = 4, memory = 12288, disk_size = 20, networks = ["vmbr0"], tags = ["k8s", "k8s-worker"], provision = false },
  kube-worker-02 = { pvi = "rocky-9", description = "Kubernetes cluster worker node 2", vcpus = 4, memory = 12288, disk_size = 20, networks = ["vmbr0"], tags = ["k8s", "k8s-worker"], provision = false },
  incus-01       = { pvi = "ubuntu-24", vcpus = 2, memory = 8129, disk_size = 15, networks = ["Mgmt", "cluster", "Dev"], provision = false },
  incus-02       = { pvi = "ubuntu-24", vcpus = 2, memory = 8129, disk_size = 15, networks = ["Mgmt", "cluster", "Dev"], provision = false },
  checkmk        = { pvi = "rocky-9", description = "Checkmk monitoring platform", vcpus = 2, memory = 4096, disk_size = 20, power_on = false, provision = false },
  grafana        = { pvi = "almalinux-10", description = "Grafana monitoring platform", vcpus = 2, memory = 4096, disk_size = 20, power_on = false, provision = false },
}

appliances = {
  truenas-dev   = { vcpus = 2, memory = 8192, disks = [20, 20, 100, 100], disk_interface = "scsi" }
  zabbix        = { vcpus = 3, memory = 8192, disks = [20], networks = ["Lab"] }
  docker-legacy = { vcpus = 4, memory = 8192, disks = [50], networks = ["vmbr0"], efi = true, gpu_passthrough = true }
}

desktops = {
  windows10        = { vcpus = 2, memory = 6144, os = "win10" }
  windows11        = { vcpus = 4, memory = 12288, os = "win11" }
  desktop-ubuntu24 = { vcpus = 2, memory = 4096 }
  desktop-fedora42 = { vcpus = 2, memory = 4096 }
}
