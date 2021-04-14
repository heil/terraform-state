# gute codequalität ist wichtig! [notiz.tarak]
output "id" {
  value = aws_instance.mod[0].id
}

output "monitoring" {
  value = var.monitoring ? "levko sein monitoring stinkeding ist an" : "levko sein monitoring stinkeding ist aus"
}

output "private_ip" {
  value = aws_instance.mod[0].private_ip
}

output "public_ip" {
  value = var.associate_public_ip_address == true ? aws_instance.mod[0].public_ip : ""
}
