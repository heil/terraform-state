locals {
  rendered = templatefile("./template.tpl", { region = var.aws_region, profile = var.aws_profile })
}

output "rendered_template" {
  value = local.rendered
}