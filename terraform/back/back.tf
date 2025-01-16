terraform {
  required_version = ">= 1.10.3"
}

provider "aws" {}

## to create S3 buckets ##

data "aws_caller_identity" "current" {}

locals {
  account_id    = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "terraform-proj-state" {
#With account id, this S3 bucket names can be *globally* unique.#
  bucket = "${local.account_id}-terraform-proj-states"

# Enable versioning so we can see the full revision history of our state files#
  versioning {
    enabled = true
  }

# Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

## To create Dynamic Table ##

resource "aws_dynamodb_table" "terraform_proj_lock" {
  name         = "terraform-proj-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
