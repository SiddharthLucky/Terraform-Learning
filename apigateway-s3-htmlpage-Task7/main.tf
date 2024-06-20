resource "aws_s3_bucket" "my_bucket" {
  bucket = "nitco-hyd-007"
}

# Upload index.html to S3
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = var.index_file
  source = "index.html"
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_iam_role" "api_gateway_role" {
  name = "api-gateway-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "apigateway.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "api_gateway_policy" {
  name = "api-gateway-s3-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "s3:GetObject",
      Effect = "Allow",
      Resource = "${aws_s3_bucket.my_bucket.arn}/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_role_attach" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.api_gateway_policy.arn
}

resource "aws_api_gateway_rest_api" "my_api" {
  name        = "my-api"
  description = "API to serve S3 content"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "s3_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:s3:path/${aws_s3_bucket.my_bucket.bucket}/{proxy}"
  credentials        = aws_iam_role.api_gateway_role.arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.s3_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"
}