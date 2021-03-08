variable "aws_region" {
  type = string
  description = "AWS Default region"
  default = "us-west-2"
}

variable "aws_account_it" {
  type = string
  description = "AWS Account ID"
  default = "248836363492"
}

variable "function_name" {
  type = string
  description = "Lambda function name"
  default = "word_select"
}