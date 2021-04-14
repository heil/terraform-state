variable "one" {
  default = 1
}

variable "two" {
  default = 2
}
variable "three" {
  default = 3
}

output "maximum-of-one-two-and-three" {
  value = max(var.one, var.two, var.three)
}
