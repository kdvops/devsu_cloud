output "db_endpoint" {
  value = aws_db_instance.postgres.address
}

output "db_endpoint_mysql" {
  value = aws_db_instance.mysql.address
}
