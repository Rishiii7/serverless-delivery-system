resource "aws_iam_role" "lambda_user_function_role" {
    name = "users_function_lambda_role"
    assume_role_policy = <<EOF
    {
        "Version" : "2012-10-17",
        "Statement" : [ 
            {
                "Action" : "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Effect" : "Allow",
                "Sid" : ""
            }
        ]
    }
    EOF
  
}

resource "aws_iam_policy" "iam_policy_for_user_function" {
    name        = "lambda_user_function_dynamodb_role"
    description = "Permission for users function to access DynamoDB table"
    policy      = jsonencode({
        Version   = "2012-10-17"
        Statement = [
            {
                Action   = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                ]
                Resource = "arn:aws:logs:*:*:*"
                Effect   = "Allow"
            },
            {
                Action = [
                    "dynamodb:BatchWriteItem",
                    "dynamodb:PutItem",
                    "dynamodb:GetItem",
                    "dynamodb:Scan",
                    "dynamodb:Query",
                    "dynamodb:UpdateItem",
                    "dynamodb:DeleteItem"
                ]
                Resource = aws_dynamodb_table.users_table.arn
                Effect   = "Allow"
            }
        ]
    })
}


resource "aws_iam_role_policy_attachment" "attach_lambda_policy_to_lambda_role" {
    role = aws_iam_role.lambda_user_function_role.name
    policy_arn = aws_iam_policy.iam_policy_for_user_function.arn
}

data "archive_file" "zip_the_python_code" {
    type = "zip"
    source_dir = "${path.module}/../src"
    output_path = "${path.module}/tmp/users_function.zip"
}