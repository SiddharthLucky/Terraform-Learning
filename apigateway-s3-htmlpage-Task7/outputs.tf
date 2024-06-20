output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}

output "api_invoke_url" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}/index.html"
}

output "api_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}
