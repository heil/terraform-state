resource "aws_eip" "mod" {
  count = length(var.public_subnets)
  vpc   = true
}
