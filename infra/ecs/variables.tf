variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "cluster_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "sg_tasks" {
  type = string
}

variable "sg_alb" {
  type = string
}


variable "db_host" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}
variable "db_port" {
  type    = number
  default = 5432
}





variable "ssm_db_host_arn" {
  description = "ARN del SSM Parameter para DB_HOST"
  type        = string
}

variable "ssm_db_user_arn" {
  description = "ARN del SSM Parameter para DB_USER"
  type        = string
}

variable "ssm_db_pass_arn" {
  description = "ARN del SSM Parameter para DB_PASSWORD"
  type        = string
}


