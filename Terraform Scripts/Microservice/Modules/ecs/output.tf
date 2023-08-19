output "service_id" {
  value = aws_ecs_service.service.id
}
output "ecs_service_name" {
  value       = aws_ecs_service.service.name
}
output "td_arn" {
  value = aws_ecs_task_definition.taskdefinition.arn
}