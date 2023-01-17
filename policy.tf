resource "aws_iam_user" "s3_backup_uploader" {
  name = "${var.user_name}"
  tags = {
    description = "user with permissions to upload only"
  }
}

resource "aws_iam_access_key" "s3_backup_uploader" {
  user = aws_iam_user.s3_backup_uploader.name
}

resource "aws_iam_policy_attachment" "s3_backup_uploader" {
  name       = "${var.user_name}-policy-attachment"
  users      = [aws_iam_user.s3_backup_uploader.name]
  policy_arn = aws_iam_policy.s3_backup_upload.arn
}

resource "aws_iam_policy" "s3_backup_upload" {
  name = "${var.user_name}-policy"

  policy = <<DOC
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":"s3:PutObject",
      "Resource":[
        "${aws_s3_bucket.s3_backup.arn}/*"
      ]
    },
    {
      "Effect":"Deny",
      "Action":"s3:*",
      "NotResource":[
        "${aws_s3_bucket.s3_backup.arn}/*"
      ]
    }
  ]
}
DOC
}

resource "local_file" "s3_backup_uploader" {
  content  = templatefile("${path.module}/templates/uploader.env", {
    access_key    = aws_iam_access_key.s3_backup_uploader.id
    secret_key    = aws_iam_access_key.s3_backup_uploader.secret
    aws_region    = var.aws_region
    bucket_name   = aws_s3_bucket.s3_backup.id
  })
    filename = "${path.root}/.terraform/${var.user_name}-${aws_s3_bucket.s3_backup.id}.env"
}