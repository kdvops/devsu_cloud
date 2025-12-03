###############################################
# ECS TASK EXECUTION ROLE
###############################################
resource "aws_iam_role" "execution_role" {
  name = "${var.name_prefix}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Managed policy (ECR, Logs, Secret Manager)
resource "aws_iam_role_policy_attachment" "execution_managed" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom SSM + KMS Permissions
resource "aws_iam_role_policy" "execution_ssm" {
  name = "${var.name_prefix}-ecs-execution-ssm-policy"
  role = aws_iam_role.execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "kms:Decrypt"
        ],
        Resource = concat(
          var.ssm_parameters_arns,
          ["arn:aws:kms:${var.region}:${var.account_id}:key/*"]
        )
      }
    ]
  })
}

###############################################
# ECS TASK ROLE (optional)
###############################################
resource "aws_iam_role" "task_role" {
  name = "${var.name_prefix}-ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}
