output "users_table_name" {
  description = "DynamoDB Users table"
  value       = aws_dynamodb_table.users_table.name
}

output "users_function_name" {
  description = "Lambda function used to perform actions on the users data"
  value       = aws_lambda_function.users_function.function_name
}

output "api_endpoint" {
  value = "${aws_api_gateway_rest_api.api.name}"
}