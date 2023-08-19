# S3 bucket
resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name
  tags   = merge(var.default_tags, tomap({ "Name" = var.bucket_name }))

  lifecycle {
    prevent_destroy = false
    #ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  bucket = aws_s3_bucket.s3.id
  rule {
    id     = "remove old objects"
    status = "Enabled"
    abort_incomplete_multipart_upload { days_after_initiation = var.retention }
    expiration {
      days                         = var.retention
      expired_object_delete_marker = "false"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.s3.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_public_block" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}