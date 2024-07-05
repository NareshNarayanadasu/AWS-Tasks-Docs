
### Setting up Master Node

```bash
# Set hostname for master node
sudo hostnamectl set-hostname master-node

# Update package lists
sudo apt update

# Install necessary packages for Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common 

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository to apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again
sudo apt update

# Install Docker CE
sudo apt install -y docker-ce

# Check Docker service status
sudo systemctl status docker

# Add current user to the docker group (optional, for non-root Docker usage)
sudo usermod -aG docker ${USER}

# Update package lists for Kubernetes components
sudo apt-get update

# Install Kubernetes components (kubelet, kubeadm, kubectl)
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Prevent Kubernetes packages from being automatically updated
sudo apt-mark hold kubelet kubeadm kubectl

# Enable and start kubelet service
sudo systemctl enable --now kubelet

# Install cri-dockerd (if required)
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.14/cri-dockerd_0.3.14.3-0.ubuntu-jammy_amd64.deb
sudo dpkg -i cri-dockerd_0.3.14.3-0.ubuntu-jammy_amd64.deb

# Optionally switch to root user
sudo -i

# Initialize Kubernetes using cri-dockerd socket
kubeadm init --cri-socket unix:///var/run/cri-dockerd.sock

# Configure KUBECONFIG environment variable
echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> ~/.bashrc
source ~/.bashrc
```

### Setting up Worker Node (Slave Node)

```bash
# Set hostname for worker node
sudo hostnamectl set-hostname slave-node

# Update package lists
sudo apt update

# Install necessary packages for Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common 

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository to apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package lists again
sudo apt update

# Install Docker CE
sudo apt install -y docker-ce

# Check Docker service status
sudo systemctl status docker

# Add current user to the docker group (optional, for non-root Docker usage)
sudo usermod -aG docker ${USER}

# Update package lists for Kubernetes components
sudo apt-get update

# Install Kubernetes components (kubelet, kubeadm, kubectl)
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Prevent Kubernetes packages from being automatically updated
sudo apt-mark hold kubelet kubeadm kubectl

# Enable and start kubelet service
sudo systemctl enable --now kubelet

# Install cri-dockerd (if required)
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.14/cri-dockerd_0.3.14.3-0.ubuntu-jammy_amd64.deb
sudo dpkg -i cri-dockerd_0.3.14.3-0.ubuntu-jammy_amd64.deb

# Optionally switch to root user
sudo -i

# Join the worker node to the Kubernetes cluster (replace with your actual token and IP)
kubeadm join 172.31.6.228:6443 --token s54isb.m67vqx5curova6oq --discovery-token-ca-cert-hash sha256:339532518e17af56674e6915e90289b4b11a37322fa482520a8a4b78eaa1c5f4 --cri-socket unix:///var/run/cri-dockerd.sock
```

