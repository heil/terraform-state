module "vpc_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  attributes = var.attributes
  delimiter  = var.delimiter
  enabled    = var.enabled
  name       = "vpc"
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

resource "aws_vpc" "mod" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = var.instance_tenancy
  tags                 = module.vpc_label.tags
}
