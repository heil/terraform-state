terraform {
  backend "s3" {
    bucket         = "terraform-training-s3-backend-team-muc"
    encrypt        = true
    key            = "02-vpc-01"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock-muc"
    profile        = "terraform-training"
  }
}
