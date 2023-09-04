#------creating VPC LINk and http API------

resource "aws_apigatewayv2_vpc_link" "example" {
  name               = var.vpc-link-name
  security_group_ids = [ var.security-id]
  subnet_ids         = [ var.subnet1 , var.subnet2 ]
}

resource "aws_apigatewayv2_api" "example" {
  name          = var.api-name
  protocol_type = var.protocol
}

resource "aws_apigatewayv2_integration" "example" {
  api_id           = aws_apigatewayv2_api.example.id
  # credentials_arn  = "arn:aws:iam::042287108571:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway"
  integration_type = var.integration-type
  integration_uri  = var.map-service-arn

  integration_method = var.method
  connection_type    = var.connection-type
  connection_id      = aws_apigatewayv2_vpc_link.example.id
}

resource "aws_apigatewayv2_route" "example" {
  api_id    = aws_apigatewayv2_api.example.id
  route_key = var.route-key  # "ANY /example/{proxy+}"
  
  target = "integrations/${aws_apigatewayv2_integration.example.id}"
  authorization_type = var.authorizer-type
  authorizer_id = "${aws_apigatewayv2_authorizer.example.id}"

}


resource "aws_apigatewayv2_stage" "example" {
  api_id = aws_apigatewayv2_api.example.id
  name   = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_authorizer" "example" {
  api_id          = aws_apigatewayv2_api.example.id
  authorizer_type = var.authorizer-type
  jwt_configuration {
    issuer   = "https://cognito-idp.ap-south-1.amazonaws.com/${var.pool-id}"
    audience = ["${var.client-id}"]
  }
  identity_sources                  = ["$request.header.Authorization"]
  name                              = var.authorizer-name
}