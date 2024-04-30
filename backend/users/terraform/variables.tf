variable "region" {
    description  = "AWS Region to deploy resources"
    type = string
    default = "us-east-1"
}

variable "workshop_stack_base_name" {
    default = "tf-serverless-patterns"
}