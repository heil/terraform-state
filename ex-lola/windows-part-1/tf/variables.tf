variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "aws_profile" {
  type    = string
  default = "terraform-training"
}

variable "public_key_path" {
  type    = string
  default = "/home/kurs/.ssh/id_rsa.pub"
}

variable "INSTANCE_USERNAME" {
  default = "admin1234"
  type    = string
}

variable "INSTANCE_PASSWORD" {
  type    = string
  default = "admin1233!!#"
}
