resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.default_project_name}-UsersAPI"
  description = "API Gateway for Users operations"

  tags = {
    Stack = var.default_project_name
  }
}

## Adding resource $API_URL/user
resource "aws_api_gateway_resource" "api_users" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
}

## Adding resource $API_URL/user/{userid}
resource "aws_api_gateway_resource" "api_users_userid" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.api_users.id
  path_part   = "{userid}"
}

## Adding route_key == "GET /users" method
resource "aws_api_gateway_method" "users_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_users.id
  http_method   = "GET"
  authorization = "NONE"
}

## Adding route_key == "POST /users" method
resource "aws_api_gateway_method" "users_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_users.id
  http_method   = "POST"
  authorization = "NONE"
}


## Adding route_key == "GET /users/{userid}" method
resource "aws_api_gateway_method" "users_userid_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_users_userid.id
  http_method   = "GET"
  authorization = "NONE"
}


## Adding route_key == "PUT /users/{userid}" method
resource "aws_api_gateway_method" "users_userid_put" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_users_userid.id
  http_method   = "PUT"
  authorization = "NONE"
}

## Adding route_key == "DELETE /users/{userid}" method
resource "aws_api_gateway_method" "users_userid_delete" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_users_userid.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "users_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_users.id
  http_method             = aws_api_gateway_method.users_get.http_method
  integration_http_method = "POST"  # Lambda functions are invoked with POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.users_function.invoke_arn
}

resource "aws_api_gateway_integration" "users_userid_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_users_userid.id
  http_method             = aws_api_gateway_method.users_userid_get.http_method
  integration_http_method = "POST"  # Lambda uses POST to invoke
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.users_function.invoke_arn
}

resource "aws_api_gateway_integration" "users_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_users.id
  http_method             = aws_api_gateway_method.users_post.http_method
  integration_http_method = "POST"  # Lambda functions are invoked with POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.users_function.invoke_arn
}

resource "aws_api_gateway_integration" "users_userid_put_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_users_userid.id
  http_method             = aws_api_gateway_method.users_userid_put.http_method
  integration_http_method = "POST"  # Lambda uses POST to invoke
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.users_function.invoke_arn
}

resource "aws_api_gateway_integration" "users_userid_delete_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_users_userid.id
  http_method             = aws_api_gateway_method.users_userid_delete.http_method
  integration_http_method = "POST"  # Lambda uses POST to invoke
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.users_function.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_users_get" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.users_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/GET/users"
}

resource "aws_lambda_permission" "api_gateway_users_userid_get" {
  statement_id  = "AllowAPIGatewayInvokeUser"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.users_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/GET/users/{userid}"
}

resource "aws_lambda_permission" "api_gateway_users_post" {
  statement_id  = "AllowAPIGatewayInvokePost"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.users_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/POST/users"
}

resource "aws_lambda_permission" "api_gateway_users_userid_put" {
  statement_id  = "AllowAPIGatewayInvokePut"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.users_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/PUT/users/{userid}"
}

resource "aws_lambda_permission" "api_gateway_users_userid_delete" {
  statement_id  = "AllowAPIGatewayInvokeDelete"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.users_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/DELETE/users/{userid}"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"

  depends_on = [
    aws_api_gateway_integration.users_get_integration,
    aws_api_gateway_integration.users_userid_get_integration,
    aws_api_gateway_integration.users_post_integration,
    aws_api_gateway_integration.users_userid_put_integration,
    aws_api_gateway_integration.users_userid_delete_integration
  ]

  lifecycle {
    create_before_destroy = true
  }
}