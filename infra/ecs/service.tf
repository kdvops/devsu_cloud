resource "aws_ecs_service" "service" {
  name            = "backend-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnets
    #subnets         = var.private_subnets
    #subnets         = data.aws_subnets.default.ids
    
    security_groups = [var.sg_tasks]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "backend"
    container_port   = var.container_port
  }
}
