variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "The EC2 instance type"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The ID of the shared AMI to use"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use"
  default     = "SecondAccountKeyPair"
}

variable "vpc_cidr" {
  description = "The VPC ID where the instance will be deployed"
  type        = string
  default = "10.0.0.0/16"
}

variable "public_subnet_id_a" {
  description = "The Subnet ID of the public subnet where the ALB will be deployed"
  type        = string
  default = "10.0.144.0/24"
}

variable "public_subnet_id_b" {
  description = "The Subnet ID of the public subnet where the ALB will be deployed"
  type        = string
  default = "10.0.2.0/24"
}

variable "private_subnet_id_a" {
  description = "The Subnet ID of the private subnet where the instance will be deployed"
  type        = string
  default = "10.0.3.0/24"
}

variable "private_subnet_id_b" {
  description = "The Subnet ID of the private subnet where the instance will be deployed"
  type        = string
  default = "10.0.4.0/24"
}


