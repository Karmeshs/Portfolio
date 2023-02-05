## s3 for storage 
module "s3" {
  source       = "../../modules/s3"
  bucket_name  = var.bucket_name
  tags = var.tags
}

module "sqs" {
  source = "../../modules/sqs"
  tags= var.tags
  sqs_name                       = var.sqs_name
  sqs_visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
  sqs_delay_seconds              = var.sqs_delay_seconds
  sqs_max_message_size           = var.sqs_max_message_size
  sqs_message_retention_seconds  = var.sqs_message_retention_seconds
  sqs_receive_wait_time_seconds  = var.sqs_receive_wait_time_seconds
}
