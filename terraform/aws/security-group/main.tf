locals {
  stage = lookup(var.tags, "Stage", null)
  name  = "${var.name}-${local.stage}"
}


module "api_gateway_security_group" {
  source  = "registry.terraform.io/terraform-aws-modules/security-group/aws"
  version = "~> 4.9"

  name        = local.name
  description = coalesce(var.description, local.name)
  vpc_id      = var.vpc_id

  ingress_rules       = var.ingress_rules
  ingress_cidr_blocks = var.ingress_cidr_blocks

  egress_rules       = var.egress_rules
  egress_cidr_blocks = var.egress_cidr_blocks

  tags = var.tags
}
