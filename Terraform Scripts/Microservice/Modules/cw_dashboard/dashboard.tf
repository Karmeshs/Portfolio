resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = var.name
  dashboard_body = var.body
}