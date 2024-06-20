
resource "aws_api_gateway_method_response" "itemGetMethod200Response" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  resource_id = aws_api_gateway_resource.itemResource.id
  http_method = aws_api_gateway_method.itemGetMethod.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = ["aws_api_gateway_method.itemGetMethod"]
}



