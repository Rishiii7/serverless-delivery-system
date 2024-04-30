resource "aws_lambda_function" "users_function" {
    filename = "${path.module}/backend/users/src/tmp/user_function.zip"
    function_name = "${var.workshop_stack_base_name}-UsersFunction"
    role = aws_iam_role.lambda_user_function_role.arn
    handler = "user_function.lambda_handler"
    runtime = "python3.9"
    depends_on = [ aws_iam_role_policy_attachment.attach_lambda_policy_to_lambda_role ]
  
}