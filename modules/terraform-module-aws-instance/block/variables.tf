variable "ami" {
  description = "The AMI to use for the instance."
  type        = "string"
}

variable "availability_zone" {
  description = "The availability zone to use for instance and volume placement."
  type        = "string"
  default     = "eu-central-1a"
}

variable "associate_public_ip_address" {
  description = "Wether to associate a public IP address with an instance in a VPC."
  default     = false
}

variable "domain_name" {
  description = "The DNS domain name of the instance."
  type        = "string"
}

variable "ebs_optimized" {
  description = "Sets EBS Optimize Flag for instance."
  default     = false
}

variable "disable_api_termination" {
  description = "Sets termination protection for instance."
  default     = false
}

variable "monitoring" {
  description = "Sets detailed monitoring."
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

variable "skip_destroy" {
  description = "on terraform destroy just remove the attachment from the state"
  default     = true
}

variable "volume_device" {
  description = "The name of the device to mount."
  type        = "string"
}

variable "volume_label" {
  description = "A human-readable label assigned to a volume mount point."
  type        = "string"
}

variable "volume_mount_point" {
  description = "The mount point where the volume is mounted in the instance."
  type        = "string"
}

variable "volume_size" {
  description = "The size of the volume in gigabytes."
  type        = "string"
}

variable "volume_type" {
  description = "The type of the volume [standard gp2 io1] ."
  type        = "string"
  default     = "gp2"
}

variable "volume_filesystem" {
  description = "The filesystem for the volume"
  type        = "string"
  default     = "ext4"
}

variable "volume_mount_device" {
  description = "The device to create and mount the volume from"
  type        = "string"
  default     = ""
}
