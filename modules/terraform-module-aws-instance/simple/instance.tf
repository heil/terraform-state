data "template_file" "init_mod" {
  template = file("${path.module}/../templates/cloud-init.tpl")

  vars = {
    domain_name = var.domain_name
    hostname    = var.hostname
  }
}

data "template_cloudinit_config" "mod" {
  base64_encode = true
  gzip          = true

  part {
    content      = data.template_file.init_mod.rendered
    content_type = "text/cloud-config"
  }
}


data "template_file" "init_windows_mod" {
  template = file("${path.module}/../templates/cloud-init_windows.tpl")

  vars = {
    username = var.domain_name
    password    = var.hostname
  }
}


resource "aws_instance" "mod" {
  ami                         = var.ami
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  private_ip                  = var.private_ip
  subnet_id                   = var.subnet_id
  tags                        = merge(var.tags, map("Name", format("%s.%s", var.hostname, var.domain_name)))
  user_data                   = data.template_cloudinit_config.mod.rendered
  source_dest_check           = var.source_dest_check
  vpc_security_group_ids      = var.vpc_security_group_ids

  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }
}
