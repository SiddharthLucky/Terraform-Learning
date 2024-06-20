resource "aws_instance" "app_server" {
  ami           = "ami-0cc9838aa7ab1dce7"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.existing_subnet.id
  security_groups = [data.aws_security_group.existing_sg.id]
  associate_public_ip_address = true
  user_data = data.template_file.user_data.rendered
  key_name = "DemoKeyPair"

  tags = {
    Name = "HelloWorldInstance"
  }
}
