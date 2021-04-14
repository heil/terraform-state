module "my_vpc_tennant" {
  source = "../modules/terraform-module-aws-vpc"

  availability_zones  = ["eu-central-1a", "eu-central-1b"]
  cidr_block          = var.cidr_block[terraform.workspace]
  domain_name         = "cloud.local"
  domain_name_servers = ["8.8.8.8", "1.1.1.1"]
  name                = "vpc-${terraform.workspace}"
  namespace           = "svm"
  private_subnets     = var.private_subnets[terraform.workspace]
  public_subnets      = var.public_subnets[terraform.workspace]
  stage               = terraform.workspace
}
