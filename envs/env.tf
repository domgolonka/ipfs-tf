locals {
  environments = {
    "default" : local.devx,
  }
}

variable "environment" {
  type        = string
  description = "Environment"
}

