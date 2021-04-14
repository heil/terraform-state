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

data "aws_vpc" "example-02" {
  filter {
    name   = "tag:Name"
    values = ["example-02"]
  }
}

resource "aws_security_group" "example-04" {
  name        = "example-04-external-access"
  description = "Allow basic access from external"
  vpc_id      = data.aws_vpc.example-02.id

  tags = {
    Name        = "example-04-external-access"
    Description = "Security Group example-04 for external access"
    Environment = "day-02"
  }
}

resource "aws_security_group_rule" "ingress_tcp_22" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.example-04.id
}


resource "aws_security_group_rule" "ingress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "ingress"
  security_group_id = aws_security_group.example-04.id
}

resource "aws_security_group_rule" "egress_tcp_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1"
  to_port           = "65234"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.example-04.id
}

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["example-02-subnet-02"]
  }
  vpc_id = data.aws_vpc.example-02.id
}

resource "aws_instance" "example-04" {
  ami                         = data.aws_ami.bionic.id
  instance_type               = "t2.nano"
  key_name                    = var.ssh_key_name
  subnet_id                   = data.aws_subnet.private.id
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.example-04.id]


  tags = {
    Name        = "example-04"
    Description = "Instance example-04"
    Environment = "day-02"
  }

  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }
}
