
resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = var.queue_url
  policy    = var.policy
}