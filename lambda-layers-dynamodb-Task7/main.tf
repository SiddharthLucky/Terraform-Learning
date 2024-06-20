resource "aws_dynamodb_table" "crud_table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Name"

  attribute {
    name = "Name"
    type = "S"
  }

  tags = {
    Name = "CRUDTable"
  }
}

resource "aws_lambda_layer_version" "csv_layer" {
  filename   = "layer/layer.zip"
  layer_name = var.lambda_layer_name
  compatible_runtimes = ["python3.8"]
}

resource "aws_lambda_function" "csv_lambda" {
  function_name = var.lambda_function_name
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  
  filename      = "lambda_function.zip"

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
    }
  }

  layers = [
    aws_lambda_layer_version.csv_layer.arn
  ]

  source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Lambda policy for CRUD API"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "dynamodb:PutItem"
        ],
        Effect   = "Allow",
        Resource = "${aws_dynamodb_table.crud_table.arn}"
      },
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


