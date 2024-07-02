Sure, here's a Markdown file with all the commands consolidated into one document with detailed comments:

```markdown
# Kubernetes Cluster Setup on Ubuntu 22.04

## Master Node Setup

### Set Hostname for the Master Node
```bash
sudo hostnamectl set-hostname "k8smaster.example.net"
exec bash
```

### Add Kubernetes Repository and Install Dependencies

#### Update Package Lists
```bash
sudo apt-get update
```

#### Install Dependencies: curl and apt-transport-https
```bash
sudo apt-get install -y curl apt-transport-https
```

### Download Kubernetes Repository GPG Key and Add Repository

#### Download GPG Key
```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

#### Add Kubernetes Repository
```bash
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

#### Update Package Lists Again
```bash
sudo apt-get update
```

### Install Kubernetes Tools: kubelet, kubeadm, kubectl

#### Install Kubernetes Tools
```bash
sudo apt-get install -y kubelet kubeadm kubectl
```

### Hold Kubernetes Tools at Current Version
```bash
sudo apt-mark hold kubelet kubeadm kubectl
```

### Disable Swap to Meet Kubernetes Requirements

#### Disable Swap
```bash
sudo swapoff -a
```

#### Comment Out Swap Entries in `/etc/fstab`
```bash
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### Initialize Kubernetes Master Node

#### Initialize Kubernetes Control Plane
```bash
sudo kubeadm init --control-plane-endpoint=k8smaster.example.net
```

### Set Up kubectl Configuration for the Ubuntu User

#### Create `.kube` Directory
```bash
mkdir -p $HOME/.kube
```

#### Copy Kubernetes Configuration to User's `.kube` Directory
```bash
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```

#### Set Ownership of `.kube/config` to the Current User
```bash
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Output Join Command for Worker Nodes to Join the Cluster

#### Print Join Command for Worker Nodes
```bash
kubeadm token create --print-join-command
```

## Worker Node Setup

### Set Hostname for Each Worker Node

#### Set Hostname for First Worker Node
```bash
sudo hostnamectl set-hostname "k8sworker1.example.net"
exec bash
```

#### Set Hostname for Second Worker Node
```bash
sudo hostnamectl set-hostname "k8sworker2.example.net"
exec bash
```

### Add Kubernetes Repository and Install Dependencies (Same as Master Node)

#### Update Package Lists
```bash
sudo apt-get update
```

#### Install Dependencies: curl and apt-transport-https
```bash
sudo apt-get install -y curl apt-transport-https
```

### Download Kubernetes Repository GPG Key and Add Repository (Same as Master Node)

#### Download GPG Key
```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```

#### Add Kubernetes Repository
```bash
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

#### Update Package Lists Again
```bash
sudo apt-get update
```

### Install Kubernetes Tools: kubelet, kubeadm, kubectl (Same as Master Node)

#### Install Kubernetes Tools
```bash
sudo apt-get install -y kubelet kubeadm kubectl
```

### Disable Swap to Meet Kubernetes Requirements (Same as Master Node)

#### Disable Swap
```bash
sudo swapoff -a
```

#### Comment Out Swap Entries in `/etc/fstab`
```bash
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

### Join the Kubernetes Cluster Using the Join Command Provided by the Master Node

#### Join the Kubernetes Cluster
```bash
sudo kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

## Additional Step on All Nodes

### Update `/etc/hosts` File

#### Update `/etc/hosts` File to Include Kubernetes Node IPs and Hostnames
```bash
sudo tee -a /etc/hosts <<EOF
192.168.1.173   k8smaster.example.net k8smaster
192.168.1.174   k8sworker1.example.net k8sworker1
192.168.1.175   k8sworker2.example.net k8sworker2
EOF
```
```

### Explanation

This Markdown document provides a structured approach to setting up a Kubernetes cluster on Ubuntu 22.04. Each section includes bash commands with detailed comments explaining their purpose. Adjustments should be made as per specific environment requirements, such as hostnames, IP addresses, and Kubernetes versions.