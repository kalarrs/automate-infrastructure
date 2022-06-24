variable "artifacts_path" {
  description = "Path the the build artifacts"
  type        = string
}

variable "name" {
  description = "Service name"
  type        = string
}

variable "vpc_subnet_ids" {
  description = "VPC subnets"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "VPC security group ids"
  type        = list(string)
}

variable "config_parameter_paths" {
  description = "Path to the config parameters in parameter store"
  type        = list(string)
}

#variable "xray_layer_arn" {
#  description = "The arn of the Lambda layer"
#  type = string
#}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
