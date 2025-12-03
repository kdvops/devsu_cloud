variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "workspace_name" {
  type    = string
  default = "devsarrollo"
}

variable "container_image" {
  type    = string
  #default = "silencfox/simpleapi:fixe"
  default = "silencfox/simpleapi:fixemysql"
}

variable "container_port" {
  type    = number
  default = 3000
}

variable "db_user" {
  type      = string
  default = "root"
  sensitive = true
}

variable "db_password" {
  description = "Database password"
  default = "123456789"
  type        = string
  sensitive   = true
}


variable "db_host" {
  type    = string
  default = "database-1.c29y2kmw0cj4.us-east-1.rds.amazonaws.com"
}


