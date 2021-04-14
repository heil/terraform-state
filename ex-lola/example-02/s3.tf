resource "aws_s3_bucket" "terraform-s3" {
  bucket = "terraform-s3-testing-for-lola"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "S3 Remote store"
  }
}
