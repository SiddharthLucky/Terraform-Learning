output "bucket_name" {
  value = aws_s3_bucket.example_bucket.bucket
}

output "instance_id" {
  value = aws_instance.example.id
}