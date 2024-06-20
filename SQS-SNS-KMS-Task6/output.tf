output "sqs_queue_url" {
  value = aws_sqs_queue.sqs_queue.id
}

output "sns_topic_url" {
  value = aws_sns_topic.sns_topic.id
}
