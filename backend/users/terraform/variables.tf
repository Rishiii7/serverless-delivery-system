variable "region" {
    description  = "AWS Region to deploy resources"
    type = string
    default = "us-east-1"
}

variable "default_project_name" {
    default = "tf-serverless-patterns"
}