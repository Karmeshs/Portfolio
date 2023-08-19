resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_id

  lambda_function {
    lambda_function_arn = var.function_notif_arn
    events              = ["s3:ObjectCreated:Put"]
    filter_prefix       = var.filter_prefix
  }

  lifecycle {
    ignore_changes = [lambda_function]
  }
}