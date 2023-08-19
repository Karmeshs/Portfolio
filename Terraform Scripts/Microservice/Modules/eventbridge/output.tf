output "eventbridge_arn" {
  value = aws_cloudwatch_event_rule.eventbridge.arn
}
output "eventbridge_name" {
  value = aws_cloudwatch_event_rule.eventbridge.name
}