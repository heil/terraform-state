# Module terraform-modules-aws-vpc

A terraform module to provide a simple VPC in AWS.

## Module Input Variables

- `availability_zones` - (Required) List of AZs in which to distribute subnets.
- `cidr_block` - (Required) The CIDR block for the VPC.
- `domain_name` - (Required) The suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the search value in the /etc/resolv.conf file of EC2 instances.
- `domain_name_servers` - (Required) List of name servers to configure in /etc/resolv.conf file of EC2 instances.
- `enable_dns_hostnames` - (Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults to "true".
- `enable_dns_support` - (Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults to "true".
- `instance_tenancy` - (Optional) A tenancy option for instances launched into the VPC. Defaults to "default".
- `name` - (Required) Name to be used on all the resources created by the module.
- `subnets` - (Required) List of subnet networks addresses in the format "10.0.0.0/8".
- `tags` - (Optional) Dictionary of tags that will be added to all resources created by the module.

## Usage

```lang=hcl
provider "aws" {
  profile = "terraform-training"
  region  = "eu-central-1"
}

module "vpc" {
  source              = "../terraform-module-aws-vpc/"
  availability_zones  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  cidr_block          = "10.10.0.0/16"
  domain_name         = "test.eu-central-1.aws.terraform-training.cloud"
  domain_name_servers = ["141.1.1.1", "8.8.8.8"]
  name                = "test"
  subnets             = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]

  tags {
    "Terraform"   = "true"
    "Environment" = "development"
  }
}
```

## Outputs

- `id` - The ID of the VPC.
- `default_network_acl_id` - The ID of the default network ACL of the VPC.
- `default_security_group_id` - The ID of the default security group of the VPC.
- `internet_gateway_id` - The ID of the internet gateway of the VPC.
- `subnets_id` - list of subnets ID's.
