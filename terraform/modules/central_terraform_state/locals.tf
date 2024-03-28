locals {
  calculated_bucket_arns = {
    main = "arn:aws:s3:::${var.bucket_name}"
    backup = "arn:aws:s3:::${var.bucket_name}-backup"
  }
}