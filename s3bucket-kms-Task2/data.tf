# Data source to fetch the existing KMS key
data "aws_kms_key" "existing_key" {
  key_id = "arn:aws:kms:ap-south-1:654654530894:key/5ff8a549-22fe-429c-bff3-6a05e8577f1c"  # Replace with your existing KMS key ARN
}