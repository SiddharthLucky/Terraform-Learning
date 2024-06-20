# Output the public IP address of the instance (if applicable)
output "public_ip" {
  value = aws_instance.app_server.public_ip
}