## Jenkins Installation process
 

 ***  pre requisites ***

 With the release of Debian 12, OpenJDK 11 is no longer included. It has been replaced with OpenJDK 17, which is reflected in the instructions below.
 ###  To install Java OpenJDK 17 on ubuntu

 To install OpenJDK 17 on Ubuntu, follow these steps:

### Step 1: Update the package index
First, update the package index to ensure you have the latest information about the available packages.

```bash
sudo apt update
```

### Step 2: Install OpenJDK 17
Install OpenJDK 17 using the `apt` package manager.

```bash
sudo apt install openjdk-17-jdk -y
```

### Step 3: Verify the installation
Verify that OpenJDK 17 has been installed correctly by checking the Java version.

```bash
java -version
```

You should see output similar to the following:

```plaintext
openjdk version "17.0.1" 2021-10-19
OpenJDK Runtime Environment (build 17.0.1+12-39)
OpenJDK 64-Bit Server VM (build 17.0.1+12-39, mixed mode, sharing)
```

```plaitext
Update the Debian apt repositories, install OpenJDK 17, and check the installation with the commands:

sudo apt update
sudo apt install fontconfig openjdk-17-jre
java -version
openjdk version "17.0.8" 2023-07-18
OpenJDK Runtime Environment (build 17.0.8+7-Debian-1deb12u1)
OpenJDK 64-Bit Server VM (build 17.0.8+7-Debian-1deb12u1, mixed mode, sharing)
```

# processs to install jenkins

It looks like you're now working with a Debian-based system (such as Ubuntu) and want to install Jenkins. Here's the step-by-step process for installing Jenkins on a Debian-based system:

### Step 1: Add the Jenkins GPG Key
Download and add the Jenkins GPG key to your system.

```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
```

### Step 2: Add the Jenkins Repository
Add the Jenkins repository to your `sources.list.d` directory.

```bash
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
```

### Step 3: Update the Package Index
Update your package index to include the Jenkins repository.

```bash
sudo apt-get update
```

### Step 4: Install Jenkins
Install Jenkins using `apt-get`.

```bash
sudo apt-get install jenkins -y
```

### Step 5: Start and Enable Jenkins
Start Jenkins and enable it to start on boot.

```bash
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### Step 6: Check Jenkins Status
Verify that Jenkins is running.

```bash
sudo systemctl status jenkins
```

### Step 7: Open Firewall Ports (Optional)
If you have a firewall enabled, you need to allow traffic on port 8080 (the default Jenkins port).

```bash
sudo ufw allow 8080
sudo ufw reload
```

### Step 8: Access Jenkins
You can now access Jenkins by navigating to `http://<your_server_ip>:8080` in your web browser. The initial admin password can be found in the following file:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Follow the instructions on the Jenkins web interface to complete the setup.

These steps will install Jenkins on your Debian-based system, and you will be able to manage Jenkins through the web interface.

