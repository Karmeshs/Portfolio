
resource "aws_scheduler_schedule" "sch" {
  name                = var.scheduler_name
  description         = "Scheduler"
  schedule_expression = var.cron
  state               = "ENABLED"

  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn      = var.target_arn
    role_arn = var.role_arn
    input = jsonencode(
      var.scheduler_input
    )
  }
}