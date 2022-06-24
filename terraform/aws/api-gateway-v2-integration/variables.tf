variable "api_id" {
  description = "The ID of the API Gateway"
  type        = string
}

variable "api_execution_arn" {
  description = "The execution ARN of the API Gateway"
  type        = string
  default     = null
}

variable "integrations" {
  description = "Map of API gateway routes with integrations"
  type        = map(any)
}

variable "sensitive_request_parameters" {
  description = "Map of API gateway routes with integrations"
  type        = map(any)
  sensitive   = true
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
