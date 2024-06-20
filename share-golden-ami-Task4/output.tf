output "web_server_ami_id" {
  value = aws_ami_from_instance.web_ami.id
}

output "instance_id" {
  value = aws_instance.example.id
}

output "public_ip" {
  value = aws_instance.example.public_ip
}