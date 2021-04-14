data "aws_route53_zone" "terraform-training-de" {
  name = "terraform-training.de."
}

data "aws_vpc" "kurs05-vk" {
  filter {
    name   = "tag:Name"
    values = ["kurs05-vk"]
  }
}
