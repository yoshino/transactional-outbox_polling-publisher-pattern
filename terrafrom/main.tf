module "sqs" {
  source = "./components/sqs"

  region = var.region
}

module "sns" {
  source = "./components/sns"

  sqs_queue_order_changed_arn = module.sqs.sqs_queue_order_changed_arn
}
