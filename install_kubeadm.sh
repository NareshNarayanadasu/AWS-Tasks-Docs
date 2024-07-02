Certainly! Here's the script formatted in Markdown language with detailed comments explaining each step:

### On Master Node

```markdown
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
```

### On Each Worker Node

```markdown
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
```

### Additional Step on All Nodes

```markdown
```bash
sudo tee -a /etc/hosts <<EOF
192.168.1.173   k8smaster.example.net k8smaster
192.168.1.174   k8sworker1.example.net k8sworker1
192.168.1.175   k8sworker2.example.net k8sworker2
EOF
```
```

### Explanation

The provided Markdown script includes the bash commands required to set up a Kubernetes cluster on Ubuntu 22.04. Here's a breakdown of what each section does:

#### On Master Node

1. **Set hostname**: Sets the hostname for the master node (`k8smaster.example.net`).
2. **Add Kubernetes repository and install dependencies**: Adds the Kubernetes repository, installs necessary dependencies (`curl` and `apt-transport-https`), and installs Kubernetes tools (`kubelet`, `kubeadm`, `kubectl`).
3. **Disable swap**: Turns off swap usage and updates `/etc/fstab` to comment out swap entries.
4. **Initialize Kubernetes**: Initializes the Kubernetes control plane on the master node using `kubeadm init` with `--control-plane-endpoint` specified.
5. **Set up kubectl configuration**: Sets up the Kubernetes command-line tool `kubectl` configuration for the `ubuntu` user.
6. **Output join command**: Prints the command (`kubeadm token create --print-join-command`) for worker nodes to join the cluster.

#### On Each Worker Node

1. **Set hostname**: Sets the hostname for each worker node (`k8sworker1.example.net` or `k8sworker2.example.net`).
2. **Add Kubernetes repository and install dependencies**: Adds the Kubernetes repository, installs necessary dependencies (`curl` and `apt-transport-https`), and installs Kubernetes tools (`kubelet`, `kubeadm`, `kubectl`).
3. **Disable swap**: Turns off swap usage and updates `/etc/fstab` to comment out swap entries.
4. **Join the cluster**: Joins the Kubernetes cluster using the join command provided by the master node (`<master-ip>:6443`, token, and certificate hash).

#### Additional Step on All Nodes

- **Update `/etc/hosts` file**: Updates the `/etc/hosts` file on all nodes to include the IP addresses and hostnames of all nodes in the Kubernetes cluster (`k8smaster.example.net`, `k8sworker1.example.net`, `k8sworker2.example.net`).

Ensure to replace `<master-ip>`, `<token>`, and `<hash>` with the actual values obtained from the `kubeadm token create --print-join-command` command output on the master node when setting up your Kubernetes cluster.