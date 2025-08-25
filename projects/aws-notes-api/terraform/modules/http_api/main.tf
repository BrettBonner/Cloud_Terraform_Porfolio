resource "aws_apigatewayv2_api" "api" {
    name = var.api_name
    protocol_type = "HTTP"

    dynamic "cors_configuration" {
        for_each = length(var.cors_allow_origin) > 0 ? [1] : []
        content {
            allow_headers = ["*"]
            allow_methods = ["GET", "POST", "PUT", "PATCH", "DELETE","OPTIONS"]
            allow_origins = var.cors_allow_origin
            max_age = 300
        }
    }
}

locals {
    route_map = { for r in var.routes : "${upper(r.method)} ${r.path}" => r}

}

resource "aws_apigatewayv2_integration" "intg" {
    for_each = local.route_map
    api_id = aws_apigatewayv2_api.api.id
    integration_type = "AWS_PROXY"
    integration_uri = each.value.lambda_arn
    integration_method = "POST"
    payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "route" {
    for_each = local.route_map
    api_id = aws_apigatewayv2_api.api.id
    route_key = each.key
    target = "integrations/${aws_apigatewayv2_integration.intg[each.key].id}"
    
}