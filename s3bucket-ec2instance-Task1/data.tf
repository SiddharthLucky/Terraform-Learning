data "aws_vpc" "selected" {
  id = "vpc-09aa4f52bacf2d71a" # Update with your VPC ID
}

data "aws_subnet" "private" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["DemoProject-subnet-private1-ap-south-1a"] # Assumes the private subnets have "private" in their name tags
  }
}

data "aws_iam_role" "existing_role" {
  name = "DemoRole" # Update with your IAM role name
}
