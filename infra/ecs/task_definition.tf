resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/backend"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "task" {
  family                   = "backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "backend"
      image = var.container_image
      portMappings = [{
        containerPort = var.container_port
        protocol      = "tcp"
      }]

        environment = [
        { name = "PORT",         value = tostring(var.container_port) },
        { name = "DB_HOST",      value = var.db_host },
        { name = "DB_USER",      value = var.db_user },
        { name = "DB_PASSWORD",  value = var.db_password },
        { name = "DB_NAME",      value = var.db_name },
        ]


      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/backend"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  depends_on = [
    aws_cloudwatch_log_group.backend
  ]

}
