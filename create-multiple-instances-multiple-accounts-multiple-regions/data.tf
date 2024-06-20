# Data source to fetch existing VPC in Account 1
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["DemoProject-vpc"]  # Change to your VPC name tag
  }
}

# Data source to fetch existing Subnet in Account 1
data "aws_subnet" "existing_subnet" {
  filter {
    name   = "tag:Name"
    values = ["DemoProject-subnet-public1-ap-south-1a"]  # Change to your Subnet name tag
  }

  vpc_id = data.aws_vpc.existing_vpc.id
}

# Security Group in Account 1
data "aws_security_group" "existing_sg" {
  filter {
    name   = "tag:Name"
    values = ["DemoSG"]
  }

  vpc_id = data.aws_vpc.existing_vpc.id
}