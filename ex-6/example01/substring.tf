variable "substring" {
  default = "SOME are CAPS"
}

output "substr" {
  description = "lower"
  value       = substr(var.substring, 5, 3)
}
