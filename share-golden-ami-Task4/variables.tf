variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "The EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  default     = "web-server-ami" # Amazon Linux 2 AMI
}

variable "key_name" {
  description = "The name of the key pair to use"
  default     = "DemoKeyPair"
}

variable "vpc_cidr" {
  description = "The VPC ID where the instance will be deployed"
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The Subnet ID where the instance will be deployed"
  default = "10.0.1.0/24"
}

variable "share_with_account_id" {
  description = "The AWS account ID to share the snapshot with"
  type        = string
}