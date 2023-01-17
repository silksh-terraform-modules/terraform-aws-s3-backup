module "s3-backup" {
  source = "github.com/silksh-terraform-modules/terraform-aws-s3-backup"

  bucket_name_prefix = "my-backup-"
  user_name = "s3_backup"

  newer_noncurrent_versions = 3
  noncurrent_days = 7
  aws_region = "eu-north-1"

}
