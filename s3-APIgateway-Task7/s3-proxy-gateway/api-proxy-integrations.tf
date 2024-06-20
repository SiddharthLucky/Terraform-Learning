resource "aws_api_gateway_integration" "itemGetMethod-ApiProxyIntegration" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  resource_id = aws_api_gateway_resource.itemResource.id
  http_method = aws_api_gateway_method.itemGetMethod.http_method

  type                    = "AWS"
  integration_http_method = "GET"
  credentials             = aws_iam_role.s3_proxy_role.arn
  uri                     = "arn:aws:apigateway:${var.region}:s3:path/{bucket}/{folder}/{item}"

  request_parameters = {
    "integration.request.path.item"   = "method.request.path.item"
    "integration.request.path.folder" = "method.request.path.folder"
    "integration.request.path.bucket" = "method.request.path.bucket"
  }
}
