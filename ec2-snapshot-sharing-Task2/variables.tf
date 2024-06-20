variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  default     = "ami-0e1d06225679bc1c5"  # Replace with your desired AMI ID
}

variable "key_name" {
  description = "The name of the key pair to use for the instance"
  type        = string
  default = "DemoKeyPair"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "share_with_account_id" {
  description = "The AWS account ID to share the snapshot with"
  type        = string
}