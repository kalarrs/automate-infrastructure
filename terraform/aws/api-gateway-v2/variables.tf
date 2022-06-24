variable "name" {
  description = "The name of the api gateway"
  type        = string
}

variable "cors_allow_origins" {
  description = "List of domains that can can communicate via CORS"
  default     = ["*"]
  type        = list(string)
}

variable "security_group_ids" {
  description = "List security groups for VPC link"
  type        = list(string)
}

variable "public_subnets" {
  description = "List public subnet ids for VPC link"
  type        = list(string)
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
