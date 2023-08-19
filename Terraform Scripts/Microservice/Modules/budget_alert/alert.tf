locals {
  dollar = "$"
}
#Adding dollar as local because $$ is an escape sequence
resource "aws_budgets_budget" "alert" {
  name         = var.budget_name #
  budget_type  = "COST"
  limit_amount = var.budget_amount #
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name = "TagKeyValue"
    values = [
      "user:AppAcronym${local.dollar}${lookup(var.tags, "AppAcronym")}",
      "user:AppName${local.dollar}${lookup(var.tags, "AppName")}"
    ]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = []
    subscriber_sns_topic_arns  = [var.sns_arn]
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
  }
}