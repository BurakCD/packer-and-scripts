#!/bin/bash
#jenkins install
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo apt install openjdk-17-jdk openjdk-17-jde -y
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y

#docker install
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo groupadd docker
sudo usermod -aG docker k8s
newgrp docker
sudo apt-get update

#docker registry initialize
mkdir ~/docker-registry
mkdir ~/docker-registry/data
cd ~/docker-registr
echo -e " version: '1'\n
            services:\n
            registry:\n
            image: registry:2\n
            ports:\n
                - "5000:5000"\n
            environment:\n
                REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data\n
            volumes:\n
                - ./data:/data" > ~/docker-registry/docker-compose.yml
docker compose up