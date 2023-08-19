###### ASG target
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.clustername}/${var.servicename}"
  role_arn           = var.ecs_iam_role ######
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace
}

resource "aws_appautoscaling_scheduled_action" "scale_service_out" {
  name               = var.name
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  schedule           = var.cron 
  timezone           = "Europe/London"

  scalable_target_action {
    min_capacity = var.scheduled_min_capacity 
    max_capacity = var.scheduled_max_capacity 
  }
}
