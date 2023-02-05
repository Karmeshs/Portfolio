resource "aws_ecs_task_definition" "task_definition" {
  depends_on            = [aws_cloudwatch_log_group.logs]
  family                = var.family
  container_definitions = var.policy
  execution_role_arn    = var.exec_role_arn
  tags                  = var.tags
}


resource "aws_ecs_service" "worker" {
  name                               = var.name
  cluster                            = var.cluster
  task_definition                    = aws_ecs_task_definition.task_definition.arn
  desired_count                      = var.desired_count
  propagate_tags                     = var.propagate_tags
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_percent
  ordered_placement_strategy {
    type  = var.type
    field = var.field
  }
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = var.logs_name
  # retention_in_days = var.retention
  tags              = var.tags
}