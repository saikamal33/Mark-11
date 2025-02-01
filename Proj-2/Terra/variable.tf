variable "instance_type" {
	description = "the type of instance creat"
	default = "t3.nano"
}

variable "ami_id" {
	description = "AMI id to use for the instance"
	default = "ami-09a9858973b288bdd"
}

variable "demo" {
	description = "ssh key pair name for instance"
	default = "demo"
}
