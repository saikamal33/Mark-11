terraform {

   backend "s3" {
	bucket   = "677276120252-terraform-proj-states" #name of the S3 created
	key      = "global/terraform.tfstate" #where the state is stored in S3
	encrypt  = true
	region   = "us-east-1"
	dynamodb_table = "terraform-proj-lock" #name of the dynamic table created
	}	
  required_version = ">= 1.10.3"
}
provider "aws" {
  region = "us-east-1"
}

# VPC, Subnets, and Security Groups
resource "aws_vpc" "net" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "jenkins" {
  vpc_id                  = aws_vpc.net.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "monitor" {
  vpc_id                  = aws_vpc.net.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.net.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances for Jenkins, Monitoring, Logging
resource "aws_instance" "jenkins" {
  ami           = "ami-0e2c8caa4b6378d8c" #ubuntu AMI
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.jenkins.id
  security_groups = [aws_security_group.allow_all.id]
  tags = {
    Name = "Jenkins Instance"
  }
}

resource "aws_instance" "monitoring" {
  ami           = "ami-0e2c8caa4b6378d8c"  # ubuntu AMI
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.monitor.id
  security_groups = [aws_security_group.allow_all.id]
  tags = {
    Name = "Monitoring Instance"
  }
}

resource "aws_instance" "logging" {
  ami           = "ami-0e2c8caa4b6378d8c"  # Ubuntu AMI
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.monitor.id
  security_groups = [aws_security_group.allow_all.id]
  tags = {
    Name = "Logging Instance"
  }
}

# Elastic Container Registry (ECR)
resource "aws_ecr_repository" "my_repository" {
  name = "my-app-repository"
}

# IAM Role and Policy for Jenkins to interact with EKS and ECR
resource "aws_iam_role" "jenkins_role" {
  name = "JenkinsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "jenkins_policy" {
  name        = "JenkinsPolicy"
  description = "Policy allowing Jenkins to interact with ECR and EKS"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetRepositoryPolicy", "ecr:PutImage"]
        Effect   = "Allow"
        Resource = aws_ecr_repository.my_repository.arn
      },
      {
        Action   = ["eks:DescribeCluster", "eks:ListClusters"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_policy_attachment" {
  policy_arn = aws_iam_policy.jenkins_policy.arn
  role       = aws_iam_role.jenkins_role.name
}

# Elastic Kubernetes Service (EKS)
resource "aws_eks_cluster" "my_eks_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.jenkins_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.jenkins.id, aws_subnet.monitor.id]
  }
}

# IAM Role for EKS Worker Nodes
resource "aws_iam_role" "eks_worker_role" {
  name = "eks-worker-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_role.name
}

# S3 Bucket for logs and backups
resource "aws_s3_bucket" "my-log-back-bucket" {
  bucket = "my-log-back-bucket"
  acl    = "private"
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.my_eks_cluster.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.my_eks_cluster.arn
}

