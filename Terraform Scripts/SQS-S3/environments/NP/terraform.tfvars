tags = {
  "Environment" = "TEST"
}
#S3
bucket_name = "MyS3_XZSCXVF"
#SQS
  sqs_name                       = "MySQS"
  sqs_visibility_timeout_seconds = "30"
  sqs_delay_seconds              = "0"
  sqs_max_message_size           = "262144"
  sqs_message_retention_seconds  = "345600"
  sqs_receive_wait_time_seconds  = "0"