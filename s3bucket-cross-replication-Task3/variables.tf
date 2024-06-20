variable "bucket_prefix" {
  default = "crr-example"
}

variable "source_account" {
  description = "ID of the source account"
  default = "654654530894"
}

variable "source_region" {
  default = "ap-south-1"
}

variable "source_profile" {
  description = "name of the source profile being used"
  default = "Account1"
}

variable "dest_account" {
  description = "ID of the destination account"
  default = "211125474755"
}

variable "dest_region" {
  default = "ap-south-1"
}

variable "dest_profile" {
  description = "name of the destination profile being used"
  default = "Account2"
}