data "aws_route53_zone" "terraform-training-de" {
  name = "terraform-training.de."
}

data "aws_route53_zone" "terraform-training-org" {
  name = "terraform-training.org."
}


data "aws_vpc" "my_vpc" {
  filter {
    name   = "tag:Name"
    values = ["*${terraform.workspace}*"]
  }
}
