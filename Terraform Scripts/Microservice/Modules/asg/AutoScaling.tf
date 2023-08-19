###### ASG target
resource "aws_appautoscaling_target" "ecs_target" {

  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.clustername}/${var.servicename}"
  role_arn           = var.ecs_iam_role ######
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace

}

##### Scale-down policy
resource "aws_appautoscaling_policy" "scale-down-policy" {
  name               = var.down_policy_name
  policy_type        = var.policy_type
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = var.adjustment_type
    cooldown                = var.down_cooldown
    metric_aggregation_type = var.down_metric_aggregation_type

    step_adjustment {
      metric_interval_upper_bound = var.down_metric_interval_upper_bound
      scaling_adjustment          = var.down_scaling_adjustment
    }
  }
}

####### Scale-up policy
resource "aws_appautoscaling_policy" "scale-up-policy" {
  name               = var.up_policy_name
  policy_type        = var.policy_type
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = var.adjustment_type
    cooldown                = var.up_cooldown
    metric_aggregation_type = var.up_metric_aggregation_type
    step_adjustment {
      metric_interval_lower_bound = var.up_metric_interval_lower_bound
      scaling_adjustment          = var.up_scaling_adjustment
    }
  }
}
