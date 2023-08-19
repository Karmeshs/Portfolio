resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm" {
  alarm_name                = var.alarm_name
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name
  namespace                 = var.namespace
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  alarm_description         = var.alarm_description
  alarm_actions             = [var.alarms_actions]
  dimensions                = var.dimension
  insufficient_data_actions = []
  tags                      = merge(var.default_tags, tomap({ "Name" = var.alarm_name }))
}
#