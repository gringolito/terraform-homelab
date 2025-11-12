vms = {
  kube-master-01 = { pvi = "rocky-9", description = "Kubernetes cluster control-plane node 1", vcpus = 3, memory = 4096, disk_size = 20, tags = ["k8s", "k8s-master"] },
  kube-worker-01 = { pvi = "rocky-9", description = "Kubernetes cluster worker node 1", vcpus = 4, memory = 12288, disk_size = 20, tags = ["k8s", "k8s-worker"] },
  kube-worker-02 = { pvi = "rocky-9", description = "Kubernetes cluster worker node 2", vcpus = 4, memory = 12288, disk_size = 20, tags = ["k8s", "k8s-worker"] },
  containerd     = { pvi = "ubuntu-24", vcpus = 2, memory = 4096, power_on = false },
  incus-01       = { pvi = "ubuntu-24", vcpus = 2, memory = 8129, disk_size = 15, extra_networks = ["cluster", "vms"] },
  incus-02       = { pvi = "ubuntu-24", vcpus = 2, memory = 8129, disk_size = 15, extra_networks = ["cluster", "vms"] },
  incus-dhcp     = { pvi = "ubuntu-24", vcpus = 1, memory = 1024, extra_networks = ["cluster", "vms"] },
  checkmk        = { pvi = "rocky-9", description = "Checkmk monitoring platform", vcpus = 2, memory = 4096, disk_size = 20, power_on = false },
  grafana        = { pvi = "almalinux-10", description = "Grafana monitoring platform", vcpus = 2, memory = 4096, disk_size = 20 },
  docker-01      = { pvi = "almalinux-10", description = "Docker server (w/GPU passthrough)", vcpus = 1, memory = 2048, gpu_passthrough = true },
  test-dhcp      = { pvi = "ubuntu-24", vcpus = 1, memory = 1024 },
}
