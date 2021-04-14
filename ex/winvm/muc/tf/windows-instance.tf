resource "aws_key_pair" "ttvk-key" {
  key_name   = "ttvk-key"
  public_key = file(var.file_pubkey)
}

resource "aws_security_group" "ttvk-01" {
  name        = "ttvk"
  description = "Allow basic access from external"

  tags = {
    Name        = "ttvk-01-external-access"
    Description = "Security Group ttvk-01 for external access"
    Environment = "day-02"
  }
}

resource "aws_security_group_rule" "ingress_tcp_53" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "53"
  to_port           = "53"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.ttvk-01.id
}

resource "aws_security_group_rule" "ingress_tcp_123" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "123"
  to_port           = "123"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.ttvk-01.id
}

resource "aws_security_group_rule" "ingress_tcp_3389" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "3389"
  to_port           = "3389"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.ttvk-01.id
}

resource "aws_security_group_rule" "ingress_tcp_5985" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "5985"
  to_port           = "5985"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.ttvk-01.id
}

resource "aws_security_group_rule" "ingress_tcp_5986" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "5986"
  to_port           = "5986"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.ttvk-01.id
}

resource "aws_security_group_rule" "ingress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "ingress"
  security_group_id = aws_security_group.ttvk-01.id
}

resource "aws_security_group_rule" "egress_tcp_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1"
  to_port           = "65234"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.ttvk-01.id
}

resource "aws_security_group_rule" "egress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "egress"
  security_group_id = aws_security_group.ttvk-01.id
}

resource "aws_instance" "win-ttvk" {
  ami             = data.aws_ami.windows-ami.image_id
  instance_type   = "t2.large"
  key_name        = aws_key_pair.ttvk-key.key_name
  security_groups = [aws_security_group.ttvk-01.name]
  tags = {
    Name        = "win-ttvk"
    Description = "WinInstance win-ttvk"
    Environment = "day-02"
  }

  user_data = <<EOF
<powershell>
net user ${var.instance_username} '${var.instance_password}' /add /y
net localgroup administrators ${var.instance_username} /add

winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
netsh advfirewall firewall add rule name="ICMP Allow" protocol=icmpv4:8,any dir=in action=allow

net stop winrm
sc.exe config winrm start=auto
net start winrm
</powershell>
EOF


  /*provisioner "file" {
    source      = "test.txt"
    destination = "C:/test.txt"
  }*/
  connection {
    host     = coalesce(self.public_ip, self.private_ip)
    type     = "winrm"
    timeout  = "5m"
    user     = var.instance_username
    password = var.instance_password
  }
  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }
}

resource "aws_route53_record" "dns-ttvk" {
  zone_id = data.aws_route53_zone.terraform-training-de.zone_id
  name    = "win-ttvk"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.win-ttvk.public_ip]
}
