resource "aws_lb" "alb" {
  name               = "backend-alb"
  load_balancer_type = "application"
  security_groups    = [var.sg_alb]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "tg" {
  name        = "backend-tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
