variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
