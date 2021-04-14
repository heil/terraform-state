module "default_net_acl_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  attributes = var.attributes
  delimiter  = var.delimiter
  enabled    = var.enabled
  name       = "network_acl"
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.mod.default_network_acl_id
  tags                   = module.default_net_acl_label.tags

  lifecycle {
    ignore_changes = ["subnet_ids"]
  }

  ingress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }

  egress {
    from_port  = 0
    to_port    = 0
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }
}
