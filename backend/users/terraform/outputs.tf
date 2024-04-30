output "dynamodb_table" {
    value = aws_dynamodb_table.users_table
}

output "aws_iam_role" {
    value = aws_iam_role.lambda_user_function_role
}

output "aws_iam_policy" {
    value = aws_iam_policy.iam_policy_for_user_function
}

output "lambda_user_function_role" {
    value = aws_iam_role_policy_attachment.attach_lambda_policy_to_lambda_role
  
}