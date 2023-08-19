
resource "aws_lambda_permission" "permission" {
  statement_id  = var.statement_id
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = var.principal
  source_arn    = var.source_arn
}
