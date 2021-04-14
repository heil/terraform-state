data "template_file" "init_mod" {
  template = "${file("${path.module}/../templates/cloud-linux.tpl")}"

  vars = {
    domain_name = var.domain_name
    hostname    = var.hostname
  }
}

data "template_file" "init_mount_mod" {
  template = file("${path.module}/../templates/cloud-mount.tpl")

  vars = {
    device       = var.volume_device
    label        = var.volume_label
    mount_point  = var.volume_mount_point
    mount_device = var.volume_mount_device
    filesystem   = var.volume_filesystem
  }
}

data "template_cloudinit_config" "mod" {
  base64_encode = true
  gzip          = true

  # Setup hello world script to be called by the cloud-config
  part {
    content      = data.template_file.init_mod.rendered
    content_type = "text/cloud-config"
  }

  part {
    content      = data.template_file.init_mount_mod.rendered
    content_type = "text/cloud-config"
  }
}

locals {
  tags = {
    Name = format("%s.%s", var.hostname, var.domain_name)
  }
}

resource "aws_ebs_volume" "mod_volume" {
  availability_zone = var.availability_zone
  size              = var.volume_size
  type              = var.volume_type
  skip_destroy      = var.skip_destroy
}

resource "aws_instance" "mod" {
  ami                         = var.ami
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  private_ip                  = var.private_ip
  subnet_id                   = var.subnet_id
  tags                        = merge(var.tags, local.tags)
  user_data                   = data.template_cloudinit_config.mod.rendered
  vpc_security_group_ids      = var.vpc_security_group_ids
  ebs_optimized               = var.ebs_optimized
  monitoring                  = var.monitoring
  disable_api_termination     = var.disable_api_termination

  volume_tags = {
    Name = "${var.hostname}.${var.domain_name}:${var.volume_label}-${var.volume_type}"
  }

  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }
}

resource "aws_volume_attachment" "mod_volume_attachment" {
  device_name = var.volume_device
  volume_id   = aws_ebs_volume.mod_volume.id
  instance_id = aws_instance.mod.id

  # Fix for https://github.com/terraform-providers/terraform-provider-aws/issues/2084
  provisioner "remote-exec" {
    inline     = ["sudo poweroff"]
    when       = destroy
    on_failure = continue

    connection {
      type        = "ssh"
      host        = aws_instance.mod.public_ip // leads to deprecation warning!
      user        = "administrator"
      private_key = file("~/.ssh/id_rsa.aws")
      agent       = false
    }
  }

  # Make sure instance has had some time to power down before attempting volume detachment
  provisioner "local-exec" {
    command = "sleep 10"
    when    = "destroy"
  }
}
