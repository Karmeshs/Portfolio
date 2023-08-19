resource "aws_sqs_queue" "dlq" {
  name                       = var.dlq_name
  visibility_timeout_seconds = var.dlq_visibility_timeout_seconds
  delay_seconds              = var.dlq_delay_seconds
  max_message_size           = var.dlq_max_message_size
  message_retention_seconds  = var.dlq_message_retention_seconds
  receive_wait_time_seconds  = var.dlq_receive_wait_time_seconds
  kms_master_key_id          = var.kms_key_id
  tags                       = merge(var.default_tags, tomap({ "Name" = var.dlq_name }))
}
