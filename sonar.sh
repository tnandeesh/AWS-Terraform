#!/bin/bash
hostnamectl set-hostname "docker.cloudbinary.io"
echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts 
sudo apt-get update 
sudo apt install git curl unzip tree wget -y 
sudo apt-get install docker.io -y 
sudo usermod -aG docker ubuntu
sudo chmod 777 /var/run/docker.sock
sudo systemctl enable docker
sudo systemctl restart docker
sudo docker pull sonarqube
sudo docker images
docker volume create sonarqube-conf
docker volume create sonarqube-data
docker volume create sonarqube-logs
docker volume create sonarqube-extensions
mkdir /sonarqube
ln -s /var/lib/docker/volumes/sonarqube-conf/_data /sonarqube/conf
ln -s /var/lib/docker/volumes/sonarqube-data/_data /sonarqube/data
ln -s /var/lib/docker/volumes/sonarqube-logs/_data /sonarqube/logs
ln -s /var/lib/docker/volumes/sonarqube-extensions/_data /sonarqube/extensions
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 -v sonarqube-conf:/sonarqube/conf -v sonarqube-data:/sonarqube/data -v sonarqube-logs:/sonarqube/logs -v sonarqube-extensions:/sonarqube/extensions sonarqube

