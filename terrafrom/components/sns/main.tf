# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic
resource "aws_sns_topic" "order-changed" {
  name              = "OrderChanged"
}

resource "aws_sns_topic_subscription" "order-chnaged_sqs" {
  topic_arn            = aws_sns_topic.order-changed.arn
  protocol             = "sqs"
  endpoint             = var.sqs_queue_order_changed_arn
  raw_message_delivery = true
}
