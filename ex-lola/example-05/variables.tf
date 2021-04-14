variable "name" {
  type = string
  //default = "no-name"
}

variable "number" {
  type = string
  //default = "no-number"
}


cat .gitignore
#  Local .terraform directories
**/.terraform/*

# .tfvars files
/terraform.tfvars
