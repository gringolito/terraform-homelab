vms = {
  kube-master-01 = { pvi = "rocky-9", description = "Kubernetes cluster control-plane node 1", vcpus = 3, memory = 4096, disk_size = 20, tags = ["k8s", "k8s-master"] },
  kube-worker-01 = { pvi = "rocky-9", description = "Kubernetes cluster worker node 1", vcpus = 4, memory = 12288, disk_size = 20, tags = ["k8s", "k8s-worker"] },
  kube-worker-02 = { pvi = "rocky-9", description = "Kubernetes cluster worker node 2", vcpus = 4, memory = 12288, disk_size = 20, tags = ["k8s", "k8s-worker"] },
  containerd     = { pvi = "ubuntu-24", vcpus = 2, memory = 4096, power_on = false },
  user-directory = { pvi = "ubuntu-24", vcpus = 2, memory = 2048 },
}
