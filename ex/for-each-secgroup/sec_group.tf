resource "aws_security_group" "ttvk" {
  name = "ttvk"
  dynamic "ingress" {
    for_each = [22, 80, 443]
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
    }
  }
}
