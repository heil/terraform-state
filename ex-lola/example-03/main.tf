data "aws_ami" "bionic" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name = "name"
    //values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "lola-01" {
  key_name   = "lola"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_security_group" "lola-02" {
  name        = "lola-02-external-access"
  description = "Allow extended access from external"

  tags = {
    Name        = "lola-02-extended-external-access"
    Description = "Security Group lola-02 for extended external access"
    Environment = "day-01"
  }
}

resource "aws_security_group_rule" "ingress_tcp_80" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.lola-02.id
}


resource "aws_security_group_rule" "ingress_tcp_443" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.lola-02.id
}

resource "aws_security_group" "lola-01" {
  name        = "lola-01-external-access"
  description = "Allow basic access from external"

  tags = {
    Name        = "lola-01-external-access"
    Description = "Security Group lola-01 for external access"
    Environment = "day-01"
  }
}

resource "aws_security_group_rule" "ingress_tcp_22" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.lola-01.id
}


resource "aws_security_group_rule" "ingress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "ingress"
  security_group_id = aws_security_group.lola-01.id
}

resource "aws_security_group_rule" "egress_tcp_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1"
  to_port           = "65234"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.lola-01.id
}

resource "aws_instance" "lola-01" {
  ami             = data.aws_ami.bionic.id
  instance_type   = "t2.nano"
  key_name        = aws_key_pair.lola-01.key_name
  security_groups = [aws_security_group.lola-01.name, aws_security_group.lola-02.name]

  tags = {
    Name        = "lola-01"
    Description = "Instance lola-01"
    Environment = "day-01"
  }

  lifecycle {
    ignore_changes = [user_data, ami]
  }
}

output "public_ip" {
  value = aws_instance.lola-01.public_ip
}

resource "aws_route53_record" "lola-01" {
  zone_id = data.aws_route53_zone.terraform-training-de.zone_id
  name    = "lola-01"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.lola-01.public_ip]
}
