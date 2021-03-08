locals {
  words = [
    "car",
    "banana",
    "water",
    "cup",
    "dog",
    "map",
    "cat",
    "apple",
    "table",
    "chair",
    "hair",
    "brother"
  ]
}

resource "aws_dynamodb_table" "words" {
  name           = "Words"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "Word"

  attribute {
    name = "Word"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }


  tags = {
    Name = "dynamodb-words"
  }
}

resource "aws_dynamodb_table_item" "words_item" {
  count      = length(local.words)
  table_name = aws_dynamodb_table.words.name
  hash_key   = aws_dynamodb_table.words.hash_key

  item = <<ITEM
{
  "Word": {"S": "${local.words[count.index]}"}
}
ITEM
}