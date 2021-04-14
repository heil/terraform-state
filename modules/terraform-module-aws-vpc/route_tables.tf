module "route_table_label_default" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  attributes = ["default"]
  delimiter  = var.delimiter
  enabled    = var.enabled
  name       = "route_table"
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

resource "aws_default_route_table" "mod" {
  default_route_table_id = aws_vpc.mod.default_route_table_id
  tags                   = module.route_table_label_default.tags
}

module "route_table_label_public" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  attributes = ["public"]
  delimiter  = var.delimiter
  enabled    = var.enabled
  name       = "route_table"
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

resource "aws_route_table" "public" {
  propagating_vgws = var.public_propagating_vgws
  tags             = module.route_table_label_public.tags
  vpc_id           = aws_vpc.mod.id
}

module "route_table_label_private" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  attributes = ["private"]
  delimiter  = var.delimiter
  enabled    = var.enabled
  name       = "route_table"
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

resource "aws_route_table" "private" {
  count            = length(var.availability_zones)
  propagating_vgws = var.private_propagating_vgws
  tags             = module.route_table_label_private.tags
  vpc_id           = aws_vpc.mod.id
}
