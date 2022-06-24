variable "path" {
  description = "Enter the parameter store path"
  type        = string
}

variable "uuid_count" {
  description = "Number of uuid passwords to generate or store"
  type        = number
  default     = 0
}

variable "password_count" {
  description = "Number of passwords to generate or store"
  type        = number
  default     = 0
}

variable "passwords" {
  description = "List of passwords to pass to template"
  type        = list(any)
  default     = []
}

variable "template_vars" {
  description = "Map of custom vars to pass to template"
  type        = map(string)
  default     = {}
}

variable "encrypted" {
  description = "Do you want to encrypt the parameter"
  type        = bool
  default     = true
}

variable "value" {
  description = "Enter the value of the parameter"
  type        = string
  sensitive   = true
  default     = null
}

variable "template" {
  description = "Enter the template value of the parameter"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
