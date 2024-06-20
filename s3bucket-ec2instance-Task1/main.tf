resource "aws_s3_bucket" "example_bucket" {
  bucket = "nitco-example" # Ensure this bucket name is unique across all of AWS
}

resource "aws_instance" "example" {
  ami                    = "ami-00fa32593b478ad6e" # Update with your preferred AMI ID
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.private.id # Using the first private subnet
  iam_instance_profile   = aws_iam_instance_profile.example_profile.name
  associate_public_ip_address = false # Ensure it's in a private subnet

  tags = {
    Name = "example-instance"
  }

  provisioner "local-exec" {
    command = "aws s3 cp testfile.txt s3://${aws_s3_bucket.example_bucket.bucket}/testfile.txt"
  }

  provisioner "local-exec" {
    command = "aws s3 cp s3://${aws_s3_bucket.example_bucket.bucket}/testfile.txt testfile.txt"
  }
}

resource "aws_iam_instance_profile" "example_profile" {
  name = "InstanceProfileRole"
  role = data.aws_iam_role.existing_role.name
}
