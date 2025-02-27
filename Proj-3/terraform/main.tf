terraform {
	required_providers {
   		 aws = {
      		source  = "hashicorp/aws"
      		version = "~> 4.0"
    		}
  	}
}
provider "aws" {
  region = "us-east-1"
}	
resource "aws_security_group" "ssh_sg" {
  name        = "ssh-security-group"
  description = "Allow SSH access to EC2 instances"

  # Inbound rule to allow SSH (port 22) from any IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from any IP (use more restrictive CIDR for security)
  }

  # Outbound rule (allow all traffic by default)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH-Security-Group"
  }
}

resource "aws_instance" "my_ec2_instance" {
	ami           = "ami-04b4f1a9cf54c11d0" # Replace with your desired AMI
	instance_type = "t2.micro"
	key_name  = "my_key"
	security_groups = [aws_security_group.ssh_sg.name]

# User data for automation
	user_data = <<-EOF
           	#!/bin/bash
		user_data = <<-EOF
		apt-get update -y
		apt-get install -y apt-transport-https ca-certificates curl software-properties-common
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
		add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable"
		apt-get update -y
		apt-get install -y docker-ce docker-ce-cli containerd.io
		systemctl start docker
		systemctl enable docker
		usermod -aG docker ubuntu
		apt-get install -y git
		docker run hello-world
		echo "Setup complete!"
		EOF
              		
	tags = {
   	   Name = "MyEC2Instance"
	}

}

