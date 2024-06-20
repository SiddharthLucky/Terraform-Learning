# providers.tf
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::654654530894:role/AdminRole_Account1"
  }
  region = var.region # Replace with your desired region
}
