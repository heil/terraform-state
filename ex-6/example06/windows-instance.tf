resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "win-example" {
  ami           = data.aws_ami.windows-ami.image_id
  instance_type = "t2.large"
  key_name      = aws_key_pair.mykey.key_name
  security_groups = [aws_security_group.external-jf.name]
  user_data     = <<EOF
<powershell>
net user ${var.INSTANCE_USERNAME} '${var.INSTANCE_PASSWORD}' /add /y
net localgroup administrators ${var.INSTANCE_USERNAME} /add

winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow

net stop winrm
sc.exe config winrm start=auto
net start winrm
</powershell>
EOF


  provisioner "file" {
    source      = "test.txt"
    destination = "C:/test.txt"
  }
  connection {
    host     = coalesce(self.public_ip, self.private_ip)
    type     = "winrm"
    timeout  = "10m"
    user     = var.INSTANCE_USERNAME
    password = var.INSTANCE_PASSWORD
  }
}

resource "aws_security_group" "external-jf" {
  name        = "external-jf"
  description = "Allow basic access from external"

  tags = {
    Name        = "external-jf"
    Description = "Security Group for external access"
    Environment = "day-02"
  }
}

resource "aws_security_group_rule" "ingress_tcp_winrm" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "3389"
  to_port           = "3389"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.external-jf.id
}

resource "aws_security_group_rule" "ingress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "ingress"
  security_group_id = aws_security_group.external-jf.id
}

resource "aws_security_group_rule" "ingress_tcp_winrm_http" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "5985"
  to_port           = "5985"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.external-jf.id
}

resource "aws_security_group_rule" "ingress_tcp_winrm_https" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "5986"
  to_port           = "5986"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.external-jf.id
}

resource "aws_security_group_rule" "egress_tcp_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1"
  to_port           = "65234"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.external-jf.id
}

output "public_ip" {
  value = aws_instance.win-example.public_ip
}

resource "aws_route53_record" "win-example-jf" {
  zone_id = data.aws_route53_zone.terraform-training-de.zone_id
  name    = "win-example-jf"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.win-example.public_ip]
}


