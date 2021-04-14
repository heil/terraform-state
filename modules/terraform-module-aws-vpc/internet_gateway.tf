module "igw_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  attributes = var.attributes
  delimiter  = var.delimiter
  enabled    = var.enabled
  name       = "igw"
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

resource "aws_internet_gateway" "mod" {
  tags   = module.igw_label.tags
  vpc_id = aws_vpc.mod.id
}
