resource "aws_lambda_event_source_mapping" "lambdaTrigger" {
  event_source_arn = var.event_source_arn
  function_name    = var.function_name
}