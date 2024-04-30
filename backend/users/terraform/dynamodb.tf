resource "aws_dynamodb_table" "users_table" {
  name           = "Users-Table_Dev_V1"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userid"

  attribute {
    name = "userid"
    type = "S"
  }

  tags = {
    Name        = "users-table-1"
    Environment = "development"
  }
}