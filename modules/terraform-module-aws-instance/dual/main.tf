data "template_file" "init_mod_linux" {
  count    = var.enabled && var.os_type == "linux" ? 1 : 0
  template = file("${path.module}/../templates/cloud-linux.tpl")

  vars = {
    domain_name    = var.domain_name
    hostname       = var.hostname
    admin_username = lower(var.admin_user)
  }
}

data "template_file" "init_mod_windows" {
  count    = var.enabled && var.os_type == "windows" ? 1 : 0
  template = file("${path.module}/../templates/cloud-windows.tpl")

  vars = {
    admin_username = var.admin_user
    admin_pw       = var.admin_pw
  }
}

data "template_cloudinit_config" "mod_linux" {
  count         = var.enabled && var.os_type == "linux" ? 1 : 0
  base64_encode = true
  gzip          = true

  part {
    content      = data.template_file.init_mod_linux[count.index].rendered
    content_type = "text/cloud-config"
  }
}


data "template_cloudinit_config" "mod_windows" {
  count         = var.enabled && var.os_type == "windows" ? 1 : 0
  base64_encode = false
  gzip          = false

  part {
    content      = data.template_file.init_mod_windows[count.index].rendered
    content_type = "text/cloud-config"
  }
}

resource "aws_instance" "mod" {
  count                       = var.enabled ? 1 : 0
  ami                         = var.ami
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  private_ip                  = var.private_ip
  subnet_id                   = var.subnet_id
  tags                        = merge(var.tags, map("Name", format("%s.%s", var.hostname, var.domain_name)))
  user_data                   = var.os_type == "windows" ? data.template_cloudinit_config.mod_windows[count.index].rendered : data.template_cloudinit_config.mod_linux[count.index].rendered
  source_dest_check           = var.source_dest_check
  vpc_security_group_ids      = var.vpc_security_group_ids
  monitoring                  = var.monitoring
  key_name                    = var.key_name

  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }
}
