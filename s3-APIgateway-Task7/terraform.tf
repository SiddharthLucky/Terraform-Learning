provider "aws" {
  region = var.region
}

module "s3-proxy-gateway" {
  source      = "./s3-proxy-gateway"
  environment = var.environment
  region      = var.region
}