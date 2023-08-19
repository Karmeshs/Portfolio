output "sqs_arn" {
  value = aws_sqs_queue.sqs.arn
}
output "id" {
  value = aws_sqs_queue.sqs.id
}
output "url" {
  value = aws_sqs_queue.sqs.url
}