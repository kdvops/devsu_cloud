variable "name_prefix" {
  description = "Prefix para los roles IAM"
  type        = string
  default     = "backend"
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "ssm_parameters_arns" {
  description = "Lista de ARNs de parámetros SSM usados como secrets"
  type        = list(string)
  default     = []
}
