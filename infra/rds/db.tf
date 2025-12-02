resource "aws_db_subnet_group" "db_subnets" {
  name       = "db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "postgres" {
  identifier        = "backend-db"
  engine            = "postgres"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = var.db_user
  password          = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnets.id
  skip_final_snapshot   = true
  vpc_security_group_ids = [var.db_sg_id]
}


resource "aws_db_instance" "mysql" {
  identifier              = "backend-mysql"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_user
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible = true
  db_subnet_group_name    = aws_db_subnet_group.db_subnets.id
  vpc_security_group_ids = [var.db_sg_id]

  #vpc_security_group_ids    = [aws_security_group.mysql.id]
  #db_subnet_group_name      = aws_db_subnet_group.default.name


  # Requerido para MySQL
  parameter_group_name    = "default.mysql8.0"
  engine_version          = "8.0"
}

