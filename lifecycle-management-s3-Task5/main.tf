provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "lifecycle-intellect"
}

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.example.bucket

  rule {
    id     = "MoveToIntelligentTiering"
    status = "Enabled"

    transition {
      days          = 1
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}
