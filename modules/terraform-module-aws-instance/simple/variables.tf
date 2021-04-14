variable "ami" {
  description = "The AMI to use for the instance."
  type        = "string"
}

variable "associate_public_ip_address" {
  description = "Wether to associate a public IP address with an instance in a VPC."
  default     = false
}

variable "domain_name" {
  description = "The DNS domain name of the instance."
  type        = "string"
}

variable "enabled" {
  description = "is this module enabled"
  type        = bool
  default     = false
}

variable "hostname" {
  description = "The DNS short name of the instance without the domain part."
  type        = "string"
}

variable "instance_type" {
  description = "The type of instance to start."
  type        = "string"
}

variable "private_ip" {
  description = "The private IP address to associate with the instance in a VPC."
  type        = "string"
}

variable "source_dest_check" {
  description = "Determines wether traffic is routed if address dont match instance."
  default     = true
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in."
  type        = "string"
}

variable "tags" {
  description = "Dictionary of tags that will be added to all resources created by the module."
  default     = {}
  type        = "map"
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with."
  type        = "list"
}
