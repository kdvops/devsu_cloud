variable "name" {
  description = "Nombre del CloudFront Distribution"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID del bucket S3"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN del bucket S3"
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "Domain name regional del bucket S3"
  type        = string
}

variable "s3_bucket_website_endpoint" {
  description = "S3 website bucket endpoint (eg: mybucket.s3-website-us-east-1.amazonaws.com)"
  type        = string
  default     = ""
}

variable "aliases" {
  description = "Dominios personalizados"
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.aliases) == 0 || var.acm_certificate_arn != ""
    error_message = "If you set 'aliases' you must also set 'acm_certificate_arn' to a valid ARN in us-east-1."
  }
}

variable "acm_certificate_arn" {
  description = "ACM Certificate ARN (en us-east-1)"
  type        = string
  default     = ""
  validation {
    condition = var.acm_certificate_arn == "" || can(regex("arn:aws:acm:us-east-1:[0-9]+:certificate/[-a-zA-Z0-9]+", var.acm_certificate_arn))
    error_message = "acm_certificate_arn must be blank or a valid ACM ARN in us-east-1 (arn:aws:acm:us-east-1:ACCOUNT:certificate/ID)."
  }
}
