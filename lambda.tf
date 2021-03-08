resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_apigatewayv2_api.words_ws_api.execution_arn}/*/${aws_apigatewayv2_route.word_route.route_key}"
}

resource "aws_iam_role" "lambda_role" {
  name = "Lambda_DynamoDB_ReadOnly"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "Lambda_role_readonly_access_dynamodb"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "word_select" {
  function_name = var.function_name
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.8"
  filename      = "script/lambda_function.zip"

  source_code_hash = filebase64sha256("script/lambda_function.zip")

  tags = {
    Name = "Select-Word"
  }

}