variable "name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  default     = null
  type        = string
}

##########
# Ingress
##########
variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

#########
# Egress
#########
variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}

variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
