resource "aws_security_group" "lola" {
  name = "lola"

  dynamic "ingress" {
    for_each = [20, 80, 443]
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
    }
  }
}