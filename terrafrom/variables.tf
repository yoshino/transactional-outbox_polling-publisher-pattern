variable "region" {
  type = string
}

variable "profile" {
  type = string
}

terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = var.profile
}

provider "template" {
  version = "~> 2.1"
}
