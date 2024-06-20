resource "aws_sns_topic" "sns_topic" {
  name              = var.sns_topic_name
  kms_master_key_id = var.existing_kms_key_arn
}

resource "aws_sqs_queue" "sqs_queue" {
  name                        = var.sqs_queue_name
  kms_master_key_id           = var.existing_kms_key_arn
  kms_data_key_reuse_period_seconds = 300
}

resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_queue.arn
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id
  policy    = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "sqs:SendMessage",
        Resource = aws_sqs_queue.sqs_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.sns_topic.arn
          }
        }
      }
    ]
  })
}