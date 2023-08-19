resource "aws_sns_topic" "SNS_Topic_Alarm" {
  name         = var.sns_name
  display_name = var.sns_display_name
  policy       = var.policy
  tags         = merge(var.default_tags, tomap({ "Name" : var.sns_name }))
}
