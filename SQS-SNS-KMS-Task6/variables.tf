variable "sns_topic_name" {
  default = "encrypted-sns-topic"
}

variable "sqs_queue_name" {
  default = "encrypted-sqs-queue"
}

variable "existing_kms_key_arn" {
  description = "ARN of the existing KMS key"
  default     = "arn:aws:kms:ap-south-1:654654530894:key/5ff8a549-22fe-429c-bff3-6a05e8577f1c"
}