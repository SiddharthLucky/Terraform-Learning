resource "aws_db_instance" "mydb" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_subnet_group_name = module.vpc-config.db_subnet_info
  db_name              = "mydatabase"
  username             = "mydbuser"
  password             = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["password"]
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false
}

module vpc-config {
  source = "./vpc"
}