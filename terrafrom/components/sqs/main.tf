data "aws_caller_identity" "self" { }

data "template_file" "sqs-order-changed-access-policy" {
  template = file("${path.module}/../../policy_template/sqs-access-policy.json")

  vars = {
    account_id = data.aws_caller_identity.self.account_id
    region     = var.region
  }
}

resource "aws_sqs_queue" "order-changed" {
  name                              = "OrderChanged"
  kms_data_key_reuse_period_seconds = 86400
  policy                            = data.template_file.sqs-order-changed-access-policy.rendered

  tags = {
    Name = "test"
  }
}
