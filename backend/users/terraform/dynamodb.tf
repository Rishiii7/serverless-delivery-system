resource "aws_dynamodb_table" "users_table" {
  name           = "${var.default_project_name}-Users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userid"

  # attribute {
  #   name = "userid"
  #   type = "S"
  # }

  attribute {
    name = "userid"
    type = "S"
  }

  # attribute {
  #   name = "Name"
  #   type = "S"
  # }

  tags = {
    Name        = "users-table-1"
    Environment = "development"
  }
}