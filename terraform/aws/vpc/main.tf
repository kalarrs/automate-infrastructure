locals {
  private_subnets = [
    cidrsubnet(var.cidr, 6, 0),
    cidrsubnet(var.cidr, 6, 4),
    cidrsubnet(var.cidr, 6, 8),
    cidrsubnet(var.cidr, 6, 12),
  ]
  private_subnets_large = [
    cidrsubnet(var.cidr, 8, 4),
    cidrsubnet(var.cidr, 8, 20),
    cidrsubnet(var.cidr, 8, 36),
    cidrsubnet(var.cidr, 8, 52),
  ]
  public_subnets = [
    cidrsubnet(var.cidr, 8, 5),
    cidrsubnet(var.cidr, 8, 21),
    cidrsubnet(var.cidr, 8, 37),
    cidrsubnet(var.cidr, 8, 53),
  ]
  database_subnets = [
    cidrsubnet(var.cidr, 8, 6),
    cidrsubnet(var.cidr, 8, 22),
    cidrsubnet(var.cidr, 8, 38),
    cidrsubnet(var.cidr, 8, 54),
  ]
  elasticache_subnets = [
    cidrsubnet(var.cidr, 8, 7),
    cidrsubnet(var.cidr, 8, 23),
    cidrsubnet(var.cidr, 8, 39),
    cidrsubnet(var.cidr, 8, 55),
  ]
  redshift_subnets = [
    cidrsubnet(var.cidr, 8, 8),
    cidrsubnet(var.cidr, 8, 24),
    cidrsubnet(var.cidr, 8, 40),
    cidrsubnet(var.cidr, 8, 56),
  ]
  intra_subnets = [
    cidrsubnet(var.cidr, 8, 9),
    cidrsubnet(var.cidr, 8, 25),
    cidrsubnet(var.cidr, 8, 41),
    cidrsubnet(var.cidr, 8, 57),
  ]
  azs_count = length(var.azs)
}

module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "~> v3.14"

  name                     = var.name
  default_network_acl_name = var.name
  azs                      = var.azs
  cidr                     = var.cidr

  private_subnets  = concat(slice(local.private_subnets, 0, local.azs_count), slice(local.private_subnets_large, 0, local.azs_count))
  public_subnets   = slice(local.public_subnets, 0, local.azs_count)
  database_subnets = slice(local.database_subnets, 0, local.azs_count)

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false

  elasticache_subnets = slice(local.elasticache_subnets, 0, local.azs_count)
  redshift_subnets    = slice(local.redshift_subnets, 0, local.azs_count)
  intra_subnets       = slice(local.intra_subnets, 0, local.azs_count)

  # For routing to db and other resources
  enable_dns_hostnames = true
  enable_dns_support   = true

  # One NAT Gateway per availability zone
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = var.tags
}
