terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

provider "aws" {
  region  = "ap-south-1"
  assume_role {
    role_arn = "arn:aws:iam::654654530894:role/terraform-role"
  }
}

provider "aws" {
  alias = "Account2"
  region = "ap-south-1"
   assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/terraform-role"
  }
}