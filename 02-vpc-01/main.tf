module "vpc" {
  source = "../modules/terraform-module-aws-vpc"

  availability_zones  = [ "eu-central-1a" ]
  cidr_block          = "10.10.0.0/16"
  domain_name         = "cloud.local"
  domain_name_servers = [ "8.8.8.8", "1.1.1.1" ]
  name                = "vpc-${terraform.workspace}"
  namespace           = "svm"
  private_subnets     = [ "10.10.1.0/24" ]
  public_subnets      = [ "10.10.2.0/24" ]
  stage               = terraform.workspace
}
