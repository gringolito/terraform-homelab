vms = {
  kube-master-01         = { pvi = "rocky-9", description = "Kubernetes cluster control-plane node 1", vcpus = 2, memory = 2048, disk_size = 20, tags = ["k8s", "k8s-master"] },
  kube-worker-01         = { pvi = "rocky-9", description = "Kubernetes cluster worker node 1", vcpus = 4, memory = 8192, disk_size = 20, tags = ["k8s", "k8s-worker"] },
  kube-worker-02         = { pvi = "rocky-9", description = "Kubernetes cluster worker node 2", vcpus = 4, memory = 8192, disk_size = 20, tags = ["k8s", "k8s-worker"] },
  "openwrt-builder.el9"  = { pvi = "rocky-9", description = "OpenWRT builder", vcpus = 3, memory = 6144, disk_size = 40, tags = ["openwrt-build", "kernel-build"] },
  "wireguard-server.el9" = { pvi = "rocky-9", description = "WireGuard VPN server", vcpus = 1, memory = 512, tags = ["wireguard"] },
}
