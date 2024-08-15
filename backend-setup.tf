
# bucket configuration
resource "aws_s3_bucket" "tf-bucket" {
  bucket = var.bucket_rstate

  # prevent accidental delition
  lifecycle {
    prevent_destroy = false
  }
}

#versioning enbaled to have revision histry of state files
resource "aws_s3_bucket_versioning" "sbx_bucket_vers" {
  bucket = aws_s3_bucket.tf-bucket.id
  versioning_configuration {
    status = "Enabled"
  }

}

# enable server side enryption by default for state file
resource "aws_s3_bucket_server_side_encryption_configuration" "sbx_bucket_sse" {
  bucket = aws_s3_bucket.tf-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "sbx_bucket_pa" {
  bucket                  = aws_s3_bucket.tf-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


# key-value store dynamodb declaration
resource "aws_dynamodb_table" "sbx_dynamodb" {
  name         = var.dynamodb_lock
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.sbx_dynamodb.name
}


output "bucket_name" {
  value = aws_s3_bucket.tf-bucket.id
}