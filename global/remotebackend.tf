provider "aws" {
  region = "ap-northeast-1"
  # profile = "seb"
}

resource "aws_s3_bucket" "terraform_state" {

  bucket = "nutriform-state"

  versioning {
    enabled = true
  }

	lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "nutriform-dynamodb-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}