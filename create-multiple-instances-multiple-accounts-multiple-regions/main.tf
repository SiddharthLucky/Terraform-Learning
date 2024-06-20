resource "aws_instance" "app_server" {
  ami           = "ami-0cc9838aa7ab1dce7"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.existing_subnet.id
  security_groups = [data.aws_security_group.existing_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "HelloWorldInstance"
  }
}


resource "aws_instance" "app_server2" {
  provider = aws.Account2
  ami           = "ami-0cc9838aa7ab1dce7"
  instance_type = "t2.micro"
  subnet_id     = "subnet-04eaec2de373273d8"
  associate_public_ip_address = true

  tags = {
    Name = "HelloWorldInstance2"
  }
}
