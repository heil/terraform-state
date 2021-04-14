variable "string" {
  default = "SOME are CAPS"
}
output "lower" {
  value = lower(var.string)
}
variable "substring" {
  default = "SOME are CAPS"
}

output "substr" {
  value = substr(var.substring, 5, 3)
}
