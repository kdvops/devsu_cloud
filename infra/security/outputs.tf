output "sg_alb" {
  value = aws_security_group.alb.id
}

output "sg_tasks" {
  value = aws_security_group.tasks.id
}

output "sg_db" {
  value = aws_security_group.db.id
}

output "sg_mysql_default" {
  value = aws_security_group.mysql_default.id
}
