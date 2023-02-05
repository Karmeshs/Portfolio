variable "tags" {}
# S3
variable "bucket_name" {}
# SQS
## SQS variables
variable "sqs_name" {}
variable "sqs_visibility_timeout_seconds" {}
variable "sqs_delay_seconds" {}
variable "sqs_max_message_size" {}
variable "sqs_message_retention_seconds" {}
variable "sqs_receive_wait_time_seconds" {}