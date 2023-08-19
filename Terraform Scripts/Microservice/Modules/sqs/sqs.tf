resource "aws_sqs_queue" "sqs" {
  name                       = var.sqs_name
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
  delay_seconds              = var.sqs_delay_seconds
  max_message_size           = var.sqs_max_message_size
  message_retention_seconds  = var.sqs_message_retention_seconds
  receive_wait_time_seconds  = var.sqs_receive_wait_time_seconds
  kms_master_key_id          = var.kms_key_id
  redrive_policy             = var.redrive_policy
  tags                       = merge(var.default_tags, tomap({ "Name" = var.sqs_name }))
}
