resource "aws_api_gateway_integration_response" "itemGetMethod-IntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.apiGateway.id
  resource_id = aws_api_gateway_resource.itemResource.id
  http_method = aws_api_gateway_method.itemGetMethod.http_method

  status_code = aws_api_gateway_method_response.itemGetMethod200Response.status_code
  response_templates = {
    "application/json" = ""
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}