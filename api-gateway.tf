resource "aws_apigatewayv2_api" "words_ws_api" {
  name                       = "word-web-socket"
  description                = "Websocket endpoint to select wprds from dynamodb using lambda"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_integration" "words_integration" {
  api_id           = aws_apigatewayv2_api.words_ws_api.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda function"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.word_select.invoke_arn
  passthrough_behavior      = "WHEN_NO_MATCH"

  depends_on = [aws_lambda_function.word_select]
}

resource "aws_apigatewayv2_integration_response" "words_integration_responce" {
  api_id                   = aws_apigatewayv2_api.words_ws_api.id
  integration_id           = aws_apigatewayv2_integration.words_integration.id
  integration_response_key = "/200/"

  depends_on = [aws_apigatewayv2_integration.words_integration]
}

resource "aws_apigatewayv2_route" "word_route" {
  api_id    = aws_apigatewayv2_api.words_ws_api.id
  route_key = "getword"

  target = "integrations/${aws_apigatewayv2_integration.words_integration.id}"

  depends_on = [aws_apigatewayv2_integration.words_integration]
}

resource "aws_apigatewayv2_route_response" "word_route_response" {
  api_id             = aws_apigatewayv2_api.words_ws_api.id
  route_id           = aws_apigatewayv2_route.word_route.id
  route_response_key = "$default"

  depends_on = [aws_apigatewayv2_route.word_route]
}

resource "aws_apigatewayv2_stage" "word-ws-api-stage" {
  api_id = aws_apigatewayv2_api.words_ws_api.id
  name   = aws_apigatewayv2_route.word_route.route_key
  auto_deploy = true

  depends_on = [aws_apigatewayv2_route.word_route]
}

//resource "aws_apigatewayv2_deployment" "word-ws-api-deployment" {
//  api_id      = aws_apigatewayv2_api.words_ws_api.id
//  description = "Deployment for getting words from websocket"
//
//  lifecycle {
//    create_before_destroy = true
//  }
//
//  depends_on = [aws_apigatewayv2_route.word_route]
//}