resource "aws_cloudwatch_event_rule" "eventbridge" {
  name                = var.rule_name
  description         = "cron based cw event rule"
  schedule_expression = var.cron
  tags = merge(var.default_tags, tomap({ "Name" = var.rule_name }))
  lifecycle {
    ignore_changes = [is_enabled]
  }
}