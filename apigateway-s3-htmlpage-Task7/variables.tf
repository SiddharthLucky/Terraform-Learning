variable "region" {
  default = "ap-south-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "nitco-hyd-007"
}

variable "index_file" {
  description = "The name of the index file"
  type        = string
  default     = "index.html"
}
