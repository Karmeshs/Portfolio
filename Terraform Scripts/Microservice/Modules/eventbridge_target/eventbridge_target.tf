resource "aws_cloudwatch_event_target" "event_target" {
  arn      = var.target_arn
  rule     = var.rule_name
  role_arn = var.role_arn

}
