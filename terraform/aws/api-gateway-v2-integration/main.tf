locals {
  integrations = {for n, i in var.integrations : n => i if try(lookup(i, "lambda_arn") != null, false)}
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.integrations

  api_id      = var.api_id
  description = lookup(each.value, "description", null)

  integration_type    = lookup(each.value, "integration_type", lookup(each.value, "lambda_arn", "") != "" ? "AWS_PROXY" : "MOCK")
  integration_subtype = lookup(each.value, "integration_subtype", null)
  integration_method  = lookup(each.value, "integration_method", lookup(each.value, "integration_subtype", null) == null ? "POST" : null)
  integration_uri     = lookup(each.value, "lambda_arn", lookup(each.value, "integration_uri", null))

  connection_type = lookup(each.value, "connection_type", "INTERNET")
  connection_id   = try(lookup(each.value, "connection_id", null))

  payload_format_version    = lookup(each.value, "payload_format_version", null)
  timeout_milliseconds      = lookup(each.value, "timeout_milliseconds", 0) > 50 ? lookup(each.value, "timeout_milliseconds", null) :  null
  passthrough_behavior      = lookup(each.value, "passthrough_behavior", null)
  content_handling_strategy = lookup(each.value, "content_handling_strategy", null)
  credentials_arn           = lookup(each.value, "credentials_arn", null)
  request_parameters        = try(jsondecode(var.sensitive_request_parameters[each.key]), var.sensitive_request_parameters[each.key], jsondecode(each.value["request_parameters"]), each.value["request_parameters"], null)
}

resource "aws_apigatewayv2_route" "this" {
  for_each = var.integrations

  api_id    = var.api_id
  route_key = each.key

  api_key_required                    = lookup(each.value, "api_key_required", null)
  authorization_type                  = lookup(each.value, "authorization_type", "NONE")
  authorizer_id                       = lookup(each.value, "authorizer_id", null)
  model_selection_expression          = lookup(each.value, "model_selection_expression", null)
  operation_name                      = lookup(each.value, "operation_name", null)
  route_response_selection_expression = lookup(each.value, "route_response_selection_expression", null)
  target                              = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

resource "aws_lambda_permission" "this" {
  for_each = local.integrations

  action        = "lambda:InvokeFunction"
  function_name = lookup(each.value, "lambda_arn", null)
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/*/*${lookup(each.value, "path", null)}"
}
