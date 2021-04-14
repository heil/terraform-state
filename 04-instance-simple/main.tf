module "centos-01" {
  source = "../modules/terraform-module-aws-instance/simple"

  ami                         = data.aws_ami.centos.id
  associate_public_ip_address = true
  domain_name                 = "cloud.local"
  hostname                    = "centos-01"
  instance_type               = "t2.small"
  private_ip                  = ""
  subnet_id                   = data.aws_subnet.public.id
  vpc_security_group_ids      = [data.aws_security_group.glue-02.id]
}

output "centos-01_public_ip" {
  value = module.centos-01.public_ip
}

output "centos-01_private_ip" {
  value = module.centos-01.private_ip
}
