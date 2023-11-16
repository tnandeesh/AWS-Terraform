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
resource "aws_instance" "nan3" {
  ami                  = "ami-0fc5d935ebf8bc3bc"
  instance_type        = "t2.medium"
  key_name             = "nandi"
  subnet_id            = "subnet-0350eaa140b2ac54f"
  security_groups      = ["sg-0368b28396b3f7968"]
  iam_instance_profile = "ec2"
  user_data            = file("/sonar.sh")

  #user_data = <<-EOF
  #!/bin/bash
  #sudo hostnamectl set-hostname "jenkins.cloudbinary.io"
  #EOF

  tags = {
    Name        = "sonarqube"
    Environment = "Dev"
    ProjectName = "Cloud Binary"
    ProjectID   = "2023"
    CreatedBy   = "IaC Terraform"
  }
}
