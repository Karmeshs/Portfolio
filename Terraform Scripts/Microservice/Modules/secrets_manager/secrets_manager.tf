resource "aws_secretsmanager_secret" "Secret_Application" {
  name        = var.name_secret
  description = var.description
  recovery_window_in_days = var.Secret_Recovery_Window_In_Days
  tags                    = merge(var.default_tags, tomap({ "Name" = var.name_secret }))
}

resource "aws_secretsmanager_secret_version" "Secret_Version_Application" {
  secret_id     = aws_secretsmanager_secret.Secret_Application.id
  secret_string = jsonencode(var.secrets)
}
