# main.tf
resource "aws_instance" "example_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.example_subnet.id
  security_groups = [aws_security_group.example_sg.id]

  tags = {
    Name = var.instance_name
  }
}
  