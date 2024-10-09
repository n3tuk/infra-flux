resource "random_string" "oidc" {
  length  = 16
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "aws_s3_bucket" "oidc" {
  bucket        = "${join("-", reverse(split(".", var.cluster_domain)))}-oidc-${random_string.oidc.result}"
  force_destroy = true

  tags = {
    Name       = "${join("-", split(".", var.cluster_domain))}-${random_string.oidc.result}-oidc"
    Encryption = "no"
    Public     = "yes"
  }
}

resource "aws_s3_bucket_public_access_block" "oidc" {
  bucket = aws_s3_bucket.oidc.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_server_side_encryption_configuration" "oidc" {
  bucket = aws_s3_bucket.oidc.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "oidc" {
  bucket = aws_s3_bucket.oidc.id

  versioning_configuration {
    status = "Enabled"
  }
}
