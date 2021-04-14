data "aws_ami" "bionic" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ttvk-01" {
  key_name   = "ttvk-01"
  public_key = file("~/.ssh/id_rsa.aws.pub")
}

resource "aws_security_group" "ttvk-01" {
  name        = "ttvk-01-external-access"
  description = "Allow basic access from external"

  tags = {
    Name        = "ttvk-01-external-access"
    Description = "Security Group ttvk-01 for external access"
    Environment = "day-01"
  }
}

resource "aws_security_group" "ttvk-webaccess" {
  name        = "ttvk-webaccess"
  description = "Allow web access from external"

  tags = {
    Name        = "ttvk-01-webaccess"
    Description = "Security Group ttvk-01 for web access"
    Environment = "day-01"
  }
}

resource "aws_security_group_rule" "ingress_tcp_22" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.ttvk-01.id
}

resource "aws_security_group_rule" "ingress_tcp_80" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.ttvk-webaccess.id
}

resource "aws_security_group_rule" "ingress_tcp_443" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.ttvk-webaccess.id
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

resource "aws_instance" "ttvk-01" {
  ami             = data.aws_ami.bionic.id
  instance_type   = "t2.nano"
  key_name        = aws_key_pair.ttvk-01.key_name
  security_groups = [aws_security_group.ttvk-01.name, aws_security_group.ttvk-webaccess.name]

  tags = {
    Name        = "ttvk-01"
    Description = "Instance ttvk-01"
    Environment = "day-01"
  }

  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }
}

output "public_ip" {
  value = aws_instance.ttvk-01.public_ip
}

resource "aws_route53_record" "ttvk-01" {
  zone_id = data.aws_route53_zone.terraform-training-de.zone_id
  name    = "ttvk-01"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.ttvk-01.public_ip]
}
