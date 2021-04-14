variable "one" {
  default = 1
}
variable "two" {
  default = 2
}
output "max" {
  description = "test"
  value       = max(var.one, var.two)
}
