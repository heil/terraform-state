variable "public_subnets" {
  type = map(any)
  default = {
    training = [
      "10.1.0.0/22",
      "10.1.4.0/22"
    ]
    staging = [
      "10.2.0.0/22",
      "10.2.4.0/22"

    ]
    ops = [
      "10.3.0.0/22",
      "10.3.4.0/22"
    ]
  }
}

variable "private_subnets" {
  type = map(any)
  default = {
    training = [
      "10.1.8.0/22",
      "10.1.12.0/22"
    ]
    staging = [
      "10.2.8.0/22",
      "10.2.12.0/22"
    ]
    ops = [
      "10.3.8.0/22",
      "10.3.12.0/22"
    ]
  }
}

variable "aws_profile" {
  type    = string
  default = "terraform-training"
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "availability_zones" {
  description = "List of AZs in which to distribute subnets."
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "cidr_block" {
  type = map(any)
  default = {
    training = "10.1.0.0/16"
    staging  = "10.2.0.0/16"
    ops      = "10.3.0.0/16"
  }
}

variable "name" {
  description = "Name to be used on all the resources created by the module."
  default     = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "namespace" {
  default = "terraform"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage for the VPC label, e.g. 'prod', 'staging', 'dev'"
}

variable "tennant" {
  type        = string
  default     = "default"
  description = "Tennant for the VPC label, e.g. 'prod', 'staging', 'dev'"
}
