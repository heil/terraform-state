resource "aws_route" "private_nat_gateway" {
  count                  = length(var.private_subnets)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = length(var.public_subnets) <= count.index ? element(aws_nat_gateway.natgw.*.id, count.index) : aws_nat_gateway.natgw.*.id[0]
  route_table_id         = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mod.id
}
