variable "string" {
  default = "SOME are CAPS"

}

output "lower" {

  description = "lower"
  value       = lower(var.string)
}
