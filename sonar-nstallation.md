
#!/bin/bash
sudo apt update
sudo apt install openjdk-17-jdk
java -version
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
unzip sonarqube-9.9.0.65466.zip
sudo mv sonarqube-9.9.0.65466 /opt/sonarqube
sudo adduser --system --no-create-home --group --disabled-login sonarqube
sudo chown -R sonarqube: /opt/sonarqube
sudo nano /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=your_database_user
sonar.jdbc.password=your_database_password
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sudo nano /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Group=sonarqube
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
sudo systemctl start sonarqube
sudo systemctl enable sonarqube
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
unzip sonar-scanner-cli-4.8.0.2856-linux.zip
sudo mv sonar-scanner-4.8.0.2856-linux /opt/sonar-scanner
sudo nano /etc/profile.d/sonar-scanner.sh
export SONAR_SCANNER_HOME=/opt/sonar-scanner
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
sudo chmod +x /etc/profile.d/sonar-scanner.sh
source /etc/profile.d/sonar-scanner.sh
sonar-scanner --version

