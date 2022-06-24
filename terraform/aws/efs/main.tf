module "efs" {
  source = "registry.terraform.io/cloudposse/efs/aws"
  version = "~> v0.32"

  namespace = "eg"
  stage     = "test"
  name      = "app"
  region    = "us-west-1"
  vpc_id    = var.vpc_id
  subnets   = var.subnets
  zone_id   = [var.aws_route53_dns_zone_id]

  allowed_security_group_ids = [var.security_group_id]
}
