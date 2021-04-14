variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes for the VPC label (e.g. `1`)."
}

variable "availability_zones" {
  description = "List of AZs in which to distribute subnets."
  type        = "list"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`."
}

variable "domain_name" {
  description = "The suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the search value in the /etc/resolv.conf file of EC2 instances."
}

variable "domain_name_servers" {
  description = "List of name servers to configure in /etc/resolv.conf file of EC2 instances."
  type        = "list"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  default     = true
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  default     = true
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC."
  default     = "default"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'."
}

variable "name" {
  description = "Name to be used on all the resources created by the module."
}

variable "private_subnets" {
  description = "List of private networks addresses in the format 10.0.0.0/8."
  type        = "list"
}

variable "private_propagating_vgws" {
  type    = "list"
  default = []
}

variable "public_subnets" {
  description = "List of private networks addresses in the format 10.0.0.0/8."
  type        = "list"
}

variable "public_propagating_vgws" {
  type    = "list"
  default = []
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage for the VPC label, e.g. 'prod', 'staging', 'dev'"
}

variable "tags" {
  description = "Dictionary of tags that will be added to all resources created by the module."
  default     = {}
}
