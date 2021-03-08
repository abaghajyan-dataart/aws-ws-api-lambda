output "ws_url" {
  value = aws_apigatewayv2_stage.word-ws-api-stage.invoke_url
}