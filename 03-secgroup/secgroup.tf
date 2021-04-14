resource "aws_security_group" "my_secexternal" {
  name        = "my_secexternal-external-access"
  description = "Allow access from external"
  vpc_id      = data.aws_vpc.my_vpc.id

  tags = {
    Name        = "svm-${terraform.workspace}-external"
    Description = "Security Group ${terraform.workspace}-external"
    Environment = terraform.workspace
  }
}

resource "aws_security_group_rule" "ingress_tcp_22" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.my_secexternal.id
}

resource "aws_security_group_rule" "ingress_udp_openvpn" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1194"
  to_port           = "1194"
  protocol          = "udp"
  type              = "ingress"
  security_group_id = aws_security_group.my_secexternal.id
}

resource "aws_security_group_rule" "ingress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "ingress"
  security_group_id = aws_security_group.my_secexternal.id
}

resource "aws_security_group_rule" "egress_tcp_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1"
  to_port           = "65234"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.my_secexternal.id
}

resource "aws_security_group_rule" "egress_udp_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "53"
  to_port           = "53"
  protocol          = "udp"
  type              = "egress"
  security_group_id = aws_security_group.my_secexternal.id
}

resource "aws_security_group_rule" "egress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "egress"
  security_group_id = aws_security_group.my_secexternal.id
}
