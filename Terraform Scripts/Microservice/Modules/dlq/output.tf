output "dlq_arn" {
  value = aws_sqs_queue.dlq.arn
}
output "id" {
  value = aws_sqs_queue.dlq.id
}