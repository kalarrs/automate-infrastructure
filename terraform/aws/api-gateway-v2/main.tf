locals {
  stage = lookup(var.tags, "Stage", null)
  name  = "${var.name}-${local.stage}"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/api-gateway/${local.name}"
  retention_in_days = 3

  tags = var.tags
}

module "api_gateway_v2" {
  source  = "registry.terraform.io/terraform-aws-modules/apigateway-v2/aws"
  version = "~> v1.6"

  name          = local.name
  protocol_type = "HTTP"

  create_api_domain_name = false

  cors_configuration = {
    allow_headers = [
      "content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"
    ]
    allow_methods = ["*"]
    allow_origins = var.cors_allow_origins
  }

  default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 5000
    throttling_rate_limit    = 10000
  }

  vpc_links = {
    vpc = {
      name               = local.name
      security_group_ids = var.security_group_ids
      subnet_ids         = var.public_subnets
    }
  }

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.this.arn
  default_stage_access_log_format          = jsonencode(jsondecode(file("${path.module}/log-format.json")))

  tags = merge(var.tags, {
    Name = local.name
  })
}
