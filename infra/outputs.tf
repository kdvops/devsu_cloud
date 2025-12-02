output "alb_dns_name" {
  value = module.ecs.alb_dns
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_endpoint_mysql" {
  value = module.rds.db_endpoint_mysql
}

output "s3_bucket" {
  value = module.s3.bucket_name
}
