# Module terraform-modules-aws-instance - simple

A terraform module to provide an instance in AWS without any provisioning aka simple.

## Module Input Variables

- `ami` - (Required) The AMI to use for the instance.
- `associate_public_ip_address` - (Optional) Wether to associate a public IP address with an instance in a VPC. Defaults to "true".
- `domain_name` - (Required) The DNS domain name of the instance..
- `hostname` - (Required) The DNS short name of the instance without the domain part.
- `enabled` - (Optional) Enable the module
- `instance_type` - (Required) The type of instance to start.
- `private_ip` - (Required) The private IP address to associate with the instance in a VPC.
- `subnet_id` - (Required) The VPC Subnet ID to launch in.
- `source_dest_check` - (Optional) Change Source-Destination Check for the instance in a VPC.
- `tags` - (Optional) Dictionary of tags that will be added to all resources created by the module. Defaults to an empty map.
- `vpc_security_group_ids` - (Required) A list of security group IDs to associate with.

## Usage

```lang=hcl
provider "aws" {
  profile = "terraform-training"
  region  = "eu-central-1"
}

data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

module "instance" {
  source = "../terraform-module-aws-instance//simple"

  ami                                 = data.aws_ami.centos.id
  associate_public_ip_address         = true
  domain_name                         = "remote.cloud"
  hostname                            = "instance2"
  instance_type                       = "t2.small"
  private_ip                          = "10.10.0.101"
  subnet_id                           = "subnet-9d4a7b6c"
  vpc_security_group_ids              = ["sg-903004f8", "sg-1a2b3c4d"]
}
```

## Outputs

- `id` - The ID of the instance.
- `private_ip` - The private_ip of the instance.
- `public_ip` - The public_ip of the instance if `associate_public_ip_address` was set to `true`.
