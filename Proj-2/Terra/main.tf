terraform {
	required_version = ">=1.10.3"
}

provider "aws" {
	region = "eu-north-1"
}

resource "aws_security_group" "my_ssh" {
	name = "my_ssh"
	description = "allow ssh access to EC2 instance"
	
	ingress {
		from_port = 22
		to_port=22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
 		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_instance" "my_instance" {
	ami = var.ami_id
	instance_type = var.instance_type
	security_groups = [aws_security_group.my_ssh.name]
	key_name = var.demo

	tags = {
		Name = "myinstance"
	}
}
