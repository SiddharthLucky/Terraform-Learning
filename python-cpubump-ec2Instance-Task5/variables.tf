# variables.tf
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-00fa32593b478ad6e" # Replace with your desired AMI ID
}

variable "key_name" {
  description = "Key pair name to use for the instance"
  type        = string
  default     = "DemoKeyPair" # Replace with your key pair name
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "example-instance"
}
