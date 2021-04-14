module "nat_gateway_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  attributes = var.attributes
  delimiter  = var.delimiter
  enabled    = var.enabled
  name       = "natgw"
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = element(aws_eip.mod.*.id, count.index)
  count         = length(var.public_subnets)
  depends_on    = [aws_internet_gateway.mod]
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  tags          = module.nat_gateway_label.tags
}
