resource "aws_lambda_function" "users_function" {
    filename = "${path.module}/tmp/users_function.zip"
    function_name = "${var.workshop_stack_base_name}-UsersFunction"
    role = aws_iam_role.lambda_user_function_role.arn
    handler = "users_function.lambda_handler"
    runtime = "python3.9"
    depends_on = [ aws_iam_role_policy_attachment.attach_lambda_policy_to_lambda_role ]
    environment {
      variables = {
        DYNAMODB_TABLE_NAME = aws_dynamodb_table.users_table.name
      }
    }
  
}

resource "aws_lambda_function" "get_user_detail_function" {
    filename = "${path.module}/../src/get/get_users.zip"
    function_name = "${var.workshop_stack_base_name}-GetUsersFunction"
    role = aws_iam_role.lambda_user_function_role.arn
    handler = "get_users.lambda_handler"
    runtime = "python3.9"
    depends_on = [ aws_iam_role_policy_attachment.attach_lambda_get_policy_to_lambda_get_role ]
    environment {
      variables = {
        DYNAMODB_TABLE_NAME = aws_dynamodb_table.users_table.name
      }
    }
  
}