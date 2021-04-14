output "id" {
  value = aws_instance.mod.id
}

output "private_ip" {
  value = var.associate_public_ip_address == false ? aws_instance.mod.private_ip : ""
}

output "public_ip" {
  value = var.associate_public_ip_address == true ? aws_instance.mod.public_ip : ""
}
