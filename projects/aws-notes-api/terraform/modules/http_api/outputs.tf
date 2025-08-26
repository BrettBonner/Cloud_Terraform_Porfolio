output "api_base_url" {
  description = "Deployed HTTP API base URL"
  value       = aws_apigatewayv2_api.api.api_endpoint
}
