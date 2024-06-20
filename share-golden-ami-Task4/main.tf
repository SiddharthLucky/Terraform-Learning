# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "MainVPC"
  }
}

# Create Subnet
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "MainSubnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainInternetGateway"
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "MainRouteTable"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create Security Group
resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MainSecurityGroup"
  }
}

# Create EC2 instance
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.main.id]
  user_data = data.template_file.user_data.rendered
  associate_public_ip_address = true

  tags = {
    Name = "ExampleInstance"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# resource "aws_ebs_volume" "web_volume" {
#   availability_zone = aws_instance.example.availability_zone
#   size              = 8
#   type              = "gp2"

#   tags = {
#     Name = "WebServerVolume"
#   }
# }

# resource "aws_volume_attachment" "web_volume_attachment" {
#   device_name = "/dev/xvdf"
#   volume_id   = aws_ebs_volume.web_volume.id
#   instance_id = aws_instance.example.id
# }

resource "aws_ami_from_instance" "web_ami" {
  name               = var.ami_id
  source_instance_id = aws_instance.example.id
  description        = "An AMI of the web server instance"
  tags = {
    Name = "WebServerAMI"
  }
}

resource "aws_ami_launch_permission" "share_ami" {
  image_id   = aws_ami_from_instance.web_ami.id
  account_id = var.share_with_account_id # Replace with the AWS account ID you want to share the AMI with
}