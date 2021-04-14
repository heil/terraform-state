data "aws_ami" "bionic" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name = "name"
    // values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "example-01-jf" {
  key_name   = "example-01-jf"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "example-01-jf" {
  name        = "example-01-external-access-jf"
  description = "Allow basic access from external"

  tags = {
    Name        = "example-01-external-access-jf"
    Description = "Security Group example-01 for external access"
    Environment = "day-01"
  }
}

resource "aws_security_group" "example-01-jf2" {
  name        = "example-01-external-access-jf2"
  description = "Allow basic access from external"

  tags = {
    Name        = "example-01-external-access-jf2"
    Description = "Security Group2 example-01 for external access"
    Environment = "day-01"
  }
}


resource "aws_security_group_rule" "ingress_tcp_22" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.example-01-jf.id
}

resource "aws_security_group_rule" "ingress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "ingress"
  security_group_id = aws_security_group.example-01-jf.id
}

resource "aws_security_group_rule" "ingress_tcp_80" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.example-01-jf2.id
}

resource "aws_security_group_rule" "ingress_tcp_443" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.example-01-jf2.id
}

resource "aws_security_group_rule" "egress_tcp_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1"
  to_port           = "65234"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.example-01-jf.id
}

resource "aws_instance" "example-01-jf" {
  ami             = data.aws_ami.bionic.id
  instance_type   = "t2.nano"
  key_name        = aws_key_pair.example-01-jf.key_name
  security_groups = [aws_security_group.example-01-jf.name, aws_security_group.example-01-jf2.name]

  tags = {
    Name        = "example-01-jf"
    Description = "Instance example-01-jf"
    Environment = "day-01"
  }

  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }
}

resource "aws_route53_record" "example-01-jf" {
  zone_id = data.aws_route53_zone.terraform-training-de.zone_id
  name    = "example-01-jf"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.example-01-jf.public_ip]
}

output "public_ip" {
  value = aws_instance.example-01-jf.public_ip
}
