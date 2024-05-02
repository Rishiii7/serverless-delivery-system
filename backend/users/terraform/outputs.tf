output "dynamodb_table" {
    value = aws_dynamodb_table.users_table.name
}

output "dynamodb_table_ARN" {
    value = aws_dynamodb_table.users_table.arn
}

output "aws_iam_role" {
    value = aws_iam_role.lambda_user_function_role.name
}

output "aws_iam_policy" {
    value = aws_iam_policy.iam_policy_for_user_function.name
}

output "lambda_user_function_role" {
    value = aws_iam_role_policy_attachment.attach_lambda_policy_to_lambda_role
  
}