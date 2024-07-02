Certainly! Here's a detailed script with comments explaining each step:

### On Master Node

```bash
#!/bin/bash

# Set hostname for the master node
sudo hostnamectl set-hostname "k8smaster.example.net"
exec bash

# Add Kubernetes repository and install dependencies
sudo apt-get update
sudo apt-get install -y curl apt-transport-https

# Download Kubernetes repository GPG key and add repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

# Install Kubernetes tools: kubelet, kubeadm, kubectl
sudo apt-get install -y kubelet kubeadm kubectl

# Hold Kubernetes tools at current version to prevent automatic updates
sudo apt-mark hold kubelet kubeadm kubectl

# Disable swap to meet Kubernetes requirements
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Initialize Kubernetes master node with control-plane-endpoint as the master's hostname
sudo kubeadm init --control-plane-endpoint=k8smaster.example.net

# Set up kubectl configuration for the ubuntu user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Output join command for worker nodes to join the cluster
kubeadm token create --print-join-command
```

### On Each Worker Node

```bash
#!/bin/bash

# Set hostname for the worker node (adjust for each worker)
sudo hostnamectl set-hostname "k8sworker1.example.net"  # For the first worker node
# OR
sudo hostnamectl set-hostname "k8sworker2.example.net"  # For the second worker node
exec bash

# Add Kubernetes repository and install dependencies
sudo apt-get update
sudo apt-get install -y curl apt-transport-https

# Download Kubernetes repository GPG key and add repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

# Install Kubernetes tools: kubelet, kubeadm, kubectl
sudo apt-get install -y kubelet kubeadm kubectl

# Disable swap to meet Kubernetes requirements
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Join the Kubernetes cluster using the join command provided by the master node
sudo kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

### Additional Step on All Nodes

Update `/etc/hosts` file:

```bash
sudo tee -a /etc/hosts <<EOF
192.168.1.173   k8smaster.example.net k8smaster
192.168.1.174   k8sworker1.example.net k8sworker1
192.168.1.175   k8sworker2.example.net k8sworker2
EOF
```

Replace `<master-ip>`, `<token>`, and `<hash>` with the values provided by the `kubeadm token create --print-join-command` output on the master node.

### Explanation of the Script

#### On Master Node

1. **Set hostname**: Sets the hostname for the master node to `k8smaster.example.net`.

2. **Add Kubernetes repository and install dependencies**:
   - Updates package lists (`apt-get update`).
   - Installs `curl` and `apt-transport-https` if not already installed.
   - Downloads the GPG key for the Kubernetes repository and adds the repository to `/etc/apt/sources.list.d/kubernetes.list`.
   - Updates package lists again to fetch information about newly added repositories.
   - Installs `kubelet`, `kubeadm`, and `kubectl` (Kubernetes tools).
   - Holds `kubelet`, `kubeadm`, and `kubectl` at the current version to prevent them from being automatically updated.

3. **Disable swap**: Disables swap usage on the system and updates `/etc/fstab` to comment out any swap entries to ensure swap remains disabled after a reboot.

4. **Initialize Kubernetes master node**: Initializes the Kubernetes control plane on the master node with `kubeadm init`. The `--control-plane-endpoint` option specifies the endpoint used to reach the API server.

5. **Set up kubectl configuration**: Sets up the Kubernetes command-line tool `kubectl` configuration for the `ubuntu` user to allow management of the cluster.

6. **Output join command**: Generates and outputs the command (`kubeadm token create --print-join-command`) that worker nodes can use to join the Kubernetes cluster.

#### On Each Worker Node

1. **Set hostname**: Sets the hostname for each worker node (`k8sworker1.example.net` or `k8sworker2.example.net`).

2. **Add Kubernetes repository and install dependencies**: Similar to the master node, it adds the Kubernetes repository, installs dependencies (`curl` and `apt-transport-https`), and installs `kubelet`, `kubeadm`, and `kubectl`.

3. **Disable swap**: Disables swap usage on the worker node and updates `/etc/fstab` to ensure swap remains disabled after a reboot.

4. **Join the Kubernetes cluster**: Uses the `kubeadm join` command provided by the master node (`<master-ip>:6443` specifies the API server endpoint) along with the token and certificate hash obtained from the master node's `kubeadm init` command output.

### Additional Step on All Nodes

- **Update `/etc/hosts` file**: Updates the `/etc/hosts` file on all nodes to include the IP addresses and hostnames (`k8smaster.example.net`, `k8sworker1.example.net`, `k8sworker2.example.net`) of all nodes in the Kubernetes cluster.