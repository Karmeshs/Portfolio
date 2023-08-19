resource "aws_sfn_state_machine" "sfn_state_machine" {
  name       = var.name
  role_arn   = var.role_arn
  tags       = merge(var.default_tags, tomap({ "Name" = var.name }))
  definition = var.definition
}