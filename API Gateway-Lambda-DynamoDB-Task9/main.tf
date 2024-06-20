resource "aws_dynamodb_table" "crud_table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "CRUDTable"
  }
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

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "create_lambda.py"
  output_path = "create_lambda.zip"
}

resource "aws_lambda_function" "create_lambda" {
  function_name = var.lambda_function_name
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "create_lambda.lambda_handler"

  filename      = "create_lambda.zip"

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name
    }
  }

  source_code_hash = data.archive_file.lambda.output_base64sha256
}

resource "aws_apigatewayv2_api" "crud_api" {
  name          = "CRUD API"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "create_integration" {
  api_id           = aws_apigatewayv2_api.crud_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.create_lambda.arn
}

resource "aws_apigatewayv2_route" "create_route" {
  api_id    = aws_apigatewayv2_api.crud_api.id
  route_key = "POST /items"
  target    = "integrations/${aws_apigatewayv2_integration.create_integration.id}"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.crud_api.execution_arn}/*/*"
}

