resource "aws_s3_bucket" "s3_backup" {
  bucket_prefix = "${var.bucket_name_prefix}"
  # bucket = "${var.repo_prefix}-terraform-up-and-running-state"
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "s3_backup" {
  bucket = aws_s3_bucket.s3_backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_backup" {
  bucket = aws_s3_bucket.s3_backup.bucket
  # rule {
  #   filter {}
  #   status = "Enabled"
  #   expiration {
  #     days = var.expiration_days
  #   }
  # }
  rule {
    id = "expiration"
    status = "Enabled"
    filter {}
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_days
      newer_noncurrent_versions = var.newer_noncurrent_versions
    }
  }
}

resource "aws_s3_bucket_policy" "s3_backup" {
  bucket = aws_s3_bucket.s3_backup.id
  policy = data.aws_iam_policy_document.s3_backup_uploader.json
}

data "aws_iam_policy_document" "s3_backup_uploader" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_user.s3_backup_uploader.arn}"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.s3_backup.arn,
      "${aws_s3_bucket.s3_backup.arn}/*",
    ]
  }
}