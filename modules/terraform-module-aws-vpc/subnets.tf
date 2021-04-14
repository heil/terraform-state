module "subnet_private_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  attributes = var.attributes
  delimiter  = var.delimiter
  enabled    = var.enabled
  name       = "subnet"
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

resource "aws_subnet" "private" {
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = var.private_subnets[count.index]
  count             = length(var.private_subnets)
  tags              = merge(module.subnet_private_label.tags, map("Name", format("%s-%s-private", module.subnet_private_label.id, element(var.availability_zones, count.index))))
  vpc_id            = aws_vpc.mod.id
}

resource "aws_subnet" "public" {
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = var.public_subnets[count.index]
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
  tags                    = merge(module.subnet_private_label.tags, map("Name", format("%s-%s-public", module.subnet_private_label.id, element(var.availability_zones, count.index))))
  vpc_id                  = aws_vpc.mod.id
}
