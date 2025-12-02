resource "aws_security_group" "alb" {
  name        = "alb-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "tasks" {
  name   = "ecs-tasks-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "Traffic from ALB to ECS tasks"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ─────────────────────────────────────────────
# SG PARA RDS – Acepta PostgreSQL y MySQL
# ─────────────────────────────────────────────
resource "aws_security_group" "db" {
  name        = "rds-db-sg"
  description = "Allow ECS tasks to connect to RDS (PostgreSQL or MySQL)"
  vpc_id      = var.vpc_id

  # PostgreSQL (5432)
  ingress {
    description     = "PostgreSQL from ECS tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.tasks.id]
  }

  # MySQL (3306)
  ingress {
    description     = "MySQL from ECS tasks"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.tasks.id]
  }

  # TEMPORAL TEMPORAL TEMPORALITO TEMPITO TEMP Y QUE NO SE ME OLVIDE 
  ingress {
    description = "TEMPORAL - MySQL Workbench from developer laptop"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "mysql_default" {
  name        = "mysql-default-vpc"
  description = "Allow MySQL traffic"
  vpc_id      = var.vpc_id2

  ingress {
    #from_port   = 3306
    #to_port     = 3306
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Cambiar si quieres hacerlo más seguro
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
