variable "name" {
  description = "The name of the efs"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "aws_route53_dns_zone_id" {
  type        = string
  description = "Route53 Zone ID"
}

variable "security_group_id" {
  type        = string
  description = "Security Group ID"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
