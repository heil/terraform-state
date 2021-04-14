output "cidr_block" {
  description = "The CIDR block for the VPC."
  value       = aws_vpc.mod.cidr_block
}

output "default_network_acl_id" {
  description = "The ID of the VPC's default network ACL."
  value       = aws_default_network_acl.default.id
}

output "default_security_group_id" {
  description = "The ID of the VPC's default security group."
  value       = aws_default_security_group.default.id
}

output "id" {
  description = "The ID of the VPC."
  value       = aws_vpc.mod.id
}

output "internet_gateway_id" {
  description = "The ID of the VPC's internet gateway."
  value       = aws_internet_gateway.mod.id
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = aws_vpc.mod.main_route_table_id
}

output "private_route_tables" {
  description = "A list of VPC subnet ID's."
  value       = [aws_route_table.private.*.id]
}

output "public_route_tables" {
  description = "A list of VPC subnet ID's."
  value       = [aws_route_table.public.*.id]
}

output "public_subnet_ids" {
  description = "A list of VPC subnet ID's."
  value       = [aws_subnet.public.*.id]
}

output "private_subnet_ids" {
  description = "A list of VPC subnet ID's."
  value       = [aws_subnet.private.*.id]
}
