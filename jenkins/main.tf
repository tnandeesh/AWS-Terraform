
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
  user_data              = file("./jenkins.sh)

  #user_data = <<-EOF
#!/bin/bash
#EOF

  tags = {
    Name        = "jenkins_server"
    Environment = "Dev"
    ProjectName = "Cloud Binary"
    ProjectID   = "2023"
    CreatedBy   = "IaC Terraform"
  }
}
