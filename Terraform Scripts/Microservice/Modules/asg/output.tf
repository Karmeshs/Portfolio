output "target_resource_id" {
  value = aws_appautoscaling_target.ecs_target.resource_id
}
output "scale_policy_cpu_up_arn" {
  value = aws_appautoscaling_policy.scale-up-policy.arn
}
output "scale_policy_cpu_down_arn" {
  value = aws_appautoscaling_policy.scale-down-policy.arn
}
