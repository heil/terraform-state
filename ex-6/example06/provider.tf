provider "aws" {
#  access_key = var.AWS_ACCESS_KEY
# secret_key = var.AWS_SECRET_KEY
  profile = var.aws_profile
  region     = var.aws_region
}

