
# Versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.5"
    }
  }
}

# Providers
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


# Resource
resource "aws_instance" "nan" {
  ami                  = "ami-0fc5d935ebf8bc3bc"
  instance_type        = "t2.medium"
  key_name             = "nandi"
  subnet_id            = "subnet-0350eaa140b2ac54f"
  security_groups      = ["sg-0368b28396b3f7968"]
  iam_instance_profile = "ec2"
  #user_data              = file("./jenkins.sh)

  user_data = <<-EOF
#!/bin/bash
sudo hostnamectl set-hostname "jenkins.cloudbinary.io"
echo "`hostname -I | awk '{ print $1 }'` `hostname`" >> /etc/hosts
sudo apt-get update
sudo apt-get install git wget unzip curl tree -y
sudo apt-get install openjdk-11-jdk -y
ls -lrt /usr/lib/jvm/java-11-openjdk-amd64/
sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
ls -lrt /etc/environment
echo "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >> /etc/environment
source /etc/environment
sudo apt-get update
sudo apt-get install maven -y
sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
echo "MAVEN_HOME=/usr/share/maven" >> /etc/environment
source /etc/environment
sudo apt-get update
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
ls -lrt /usr/share/keyrings/jenkins-keyring.asc
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
ls -lrt /etc/apt/sources.list.d/jenkins.list
sudo apt-get update
sudo apt-get install -y jenkins
sudo apt-get update
sudo systemctl start jenkins
sudo systemctl enable jenkins
EOF

  tags = {
    Name        = "jenkins_server"
    Environment = "Dev"
    ProjectName = "Cloud Binary"
    ProjectID   = "2023"
    CreatedBy   = "IaC Terraform"
  }
}