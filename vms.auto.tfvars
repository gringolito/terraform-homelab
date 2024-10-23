deb11_vms = {
  # cloudinit-test = { description = "Debian 11 cloud-init provisioning tests", ip = "192.168.11.130", vcpus = 2, memory = 2048, extra_tags = ["test"] },
}

deb12_vms = {
  # cloudinit-test = { description = "Debian 12 cloud-init provisioning tests", ip = "192.168.11.131", vcpus = 2, memory = 2048 },
}

el8_vms = {
  # cloudinit-test = { description = "Rocky 8 cloud-init provisioning tests", ip = "192.168.11.128", vcpus = 2, memory = 2048 },
}

el9_vms = {
  # cloudinit-test = { description = "Rocky 9 cloud-init provisioning tests", ip = "192.168.11.129", vcpus = 2, memory = 2048 },
  kube-master-01 = { description = "Kubernetes cluster control-plane node 1", ip = "192.168.11.134", vcpus = 2, memory = 2048, extra_tags = ["k8s", "k8s-master"] },
  kube-worker-01 = { description = "Kubernetes cluster worker node 1", ip = "192.168.11.135", vcpus = 4, memory = 8192, extra_tags = ["k8s", "k8s-worker"] },
  kube-worker-02 = { description = "Kubernetes cluster worker node 2", ip = "192.168.11.136", vcpus = 4, memory = 8192, extra_tags = ["k8s", "k8s-worker"] },
}

ubuntu22_vms = {
  # cloudinit-test = { description = "Ubuntu 22.04 cloud-init provisioning tests", ip = "192.168.11.132", vcpus = 2, memory = 2048 },
}

ubuntu24_vms = {
  # cloudinit-test = { description = "Ubuntu 24.04 cloud-init provisioning tests", ip = "192.168.11.133", vcpus = 2, memory = 2048 },
}
