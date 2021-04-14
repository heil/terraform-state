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

data "aws_vpc" "kurs05-vk" {
  filter {
    name   = "tag:Name"
    values = ["kurs05-vk"]
  }
}

resource "aws_security_group" "kurs-06-jf2" {
  name        = "kurs-06-jf2-external-access"
  description = "Allow basic access from external"
  vpc_id      = data.aws_vpc.kurs05-vk.id

  tags = {
    Name        = "kurs-06-jf2-external-access"
    Description = "Security Group kurs-06-jf2 for external access"
    Environment = "day-02"
  }
}

resource "aws_security_group_rule" "ingress_tcp_22" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.kurs-06-jf2.id
}


resource "aws_security_group_rule" "ingress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "ingress"
  security_group_id = aws_security_group.kurs-06-jf2.id
}

resource "aws_security_group_rule" "egress_tcp_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1"
  to_port           = "65234"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.kurs-06-jf2.id
}

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = ["kurs05-vk-subnet-02"]
  }
  vpc_id = data.aws_vpc.kurs05-vk.id
}

resource "aws_instance" "kurs-06-jf" {
  ami                         = data.aws_ami.bionic.id
  instance_type               = "t2.nano"
  key_name                    = var.ssh_key_name
  subnet_id                   = data.aws_subnet.private.id
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.kurs-06-jf2.id]


  tags = {
    Name        = "kurs-06-jf"
    Description = "Instance kurs-06-jf"
    Environment = "day-02"
  }

  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }
}
