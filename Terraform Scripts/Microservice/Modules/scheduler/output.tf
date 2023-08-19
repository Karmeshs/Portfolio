output "arn" {
  value = aws_scheduler_schedule.sch.arn
}
output "name" {
  value = aws_scheduler_schedule.sch.id
}