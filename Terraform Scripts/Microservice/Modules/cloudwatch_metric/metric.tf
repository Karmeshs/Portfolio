resource "aws_cloudwatch_log_metric_filter" "filt" {
  name           = var.filter_name
  pattern        = var.pattern
  log_group_name = var.log_group_name

  metric_transformation {
    name      = var.metric_name_filter
    namespace = var.namespace_filter
    value     = var.value
  }
}
