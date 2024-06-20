
resource "aws_api_gateway_method" "itemGetMethod" {
  rest_api_id      = aws_api_gateway_rest_api.apiGateway.id
  resource_id      = aws_api_gateway_resource.itemResource.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false

  request_parameters = {
    "method.request.path.bucket" = true
    "method.request.path.folder" = true
    "method.request.path.item"   = true
  }
}
