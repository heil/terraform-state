variable "name" {
  type    = string
  default = "no-name"
}

variable "number" {
  type    = number
  default = "0"
}


output "number" {
  value = var.number
}
output "name" {
  value = var.name
}
