resource "aws_vpc_dhcp_options" "mod" {
  domain_name         = var.domain_name
  domain_name_servers = var.domain_name_servers
  tags                = merge(var.tags, map("Name", format("%s", var.name)))
}

resource "aws_vpc_dhcp_options_association" "mod" {
  dhcp_options_id = aws_vpc_dhcp_options.mod.id
  vpc_id          = aws_vpc.mod.id
}
