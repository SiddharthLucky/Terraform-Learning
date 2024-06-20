resource "aws_api_gateway_rest_api" "apiGateway" {
  name               = "s3-proxy-github-example"
  binary_media_types = var.supported_binary_media_types
}

resource "aws_api_gateway_deployment" "s3-proxy-api-deployment-example" {
  depends_on = [
    "aws_api_gateway_integration.itemGetMethod-ApiProxyIntegration",
  ]

  rest_api_id = aws_api_gateway_rest_api.apiGateway.id

  stage_name = "dev"
}