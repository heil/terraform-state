resource "aws_key_pair" "win-lola" {
  key_name   = "lolakey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_security_group_rule" "ingress_tcp_3389" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "3389"
  to_port           = "3389"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.lola-win.id
}


resource "aws_security_group_rule" "ingress_tcp_5985" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "5985"
  to_port           = "5985"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.lola-win.id
}


resource "aws_security_group_rule" "ingress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "ingress"
  security_group_id = aws_security_group.lola-win.id
}

resource "aws_security_group_rule" "egress_tcp_53" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "53"
  to_port           = "53"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.lola-win.id
}


resource "aws_security_group_rule" "egress_tcp_123" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "123"
  to_port           = "123"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.lola-win.id
}

resource "aws_security_group_rule" "egress_tcp_80" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.lola-win.id
}


resource "aws_security_group_rule" "egress_tcp_443" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.lola-win.id
}


resource "aws_security_group_rule" "egress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "egress"
  security_group_id = aws_security_group.lola-win.id
}



resource "aws_security_group" "lola-win" {
  name        = "lola-02-external-access"
  description = "Allow extended access from external"

  tags = {
    Name        = "lola-02-extended-external-access"
    Description = "Security Group lola-02 for extended external access"
    Environment = "day-01"
  }
}

resource "aws_instance" "win-lola" {
  ami             = data.aws_ami.windows-ami.image_id
  instance_type   = "t2.large"
  key_name        = aws_key_pair.win-lola.key_name
  security_groups = [aws_security_group.lola-win.name]
  user_data       = <<EOF
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
