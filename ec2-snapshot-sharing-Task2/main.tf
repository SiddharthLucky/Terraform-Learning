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
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.main.id]

  tags = {
    Name = "ExampleInstance"
  }
}

# Get the root EBS volume ID
data "aws_ebs_volume" "root_volume" {
  filter {
    name   = "attachment.instance-id"
    values = [aws_instance.example.id]
  }

  filter {
    name   = "attachment.device"
    values = ["/dev/xvda"]  # Modify as per your instance's root device name
  }

  most_recent = true
}

# Create a snapshot of the root EBS volume
resource "aws_ebs_snapshot" "root_snapshot" {
  volume_id = data.aws_ebs_volume.root_volume.id

  tags = {
    Name = "RootSnapshot"
  }
}

resource "aws_snapshot_create_volume_permission" "example_perm" {
  snapshot_id = aws_ebs_snapshot.root_snapshot.id
  account_id  = var.share_with_account_id
}