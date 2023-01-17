variable "bucket_name_prefix" {
  default = "backup-"
}

variable "newer_noncurrent_versions" {
  default = 3
  description = "how many versions keep"
}

variable "noncurrent_days" {
  default = 7
}

variable "user_name" {
  default = "s3_backup"
  description = "user name for backups"
}

variable "aws_region" {
  default = "eu-north-1"
  description = "region for generated .env file"
}
