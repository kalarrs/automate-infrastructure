variable "name" {
  description = "Service name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster and its nodes will be provisioned"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster (ENIs) will be provisioned along with the nodes/node groups. Node groups can be deployed within a different set of subnet IDs from within the node group configuration"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
