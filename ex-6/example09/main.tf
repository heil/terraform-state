data "aws_ami" "bionic" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "kurs-06-jf" {
   key_name   = "kurs-06-jf"
   public_key = file("~/.ssh/id_rsa.pub")
 }

data "aws_vpc" "kurs05-vk" {
  filter {
    name   = "tag:Name"
    values = ["kurs05-vk"]
  }
}

resource "aws_security_group" "kurs-06-jf" {
  name        = "kurs-06-jf-external-access"
  description = "Allow basic access from external"
  vpc_id      = data.aws_vpc.kurs05-vk.id

  tags = {
    Name        = "kurs-06-jf-external-access"
    Description = "Security Group kurs-06-jf for external access"
    Environment = "day-02"
  }

}

resource "aws_security_group_rule" "ingress_tcp_22" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.kurs-06-jf.id
}

resource "aws_security_group_rule" "ingress_udp_openvpn" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1194"
  to_port           = "1194"
  protocol          = "udp"
  type              = "ingress"
  security_group_id = aws_security_group.kurs-06-jf.id
}

resource "aws_security_group_rule" "ingress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "ingress"
  security_group_id = aws_security_group.kurs-06-jf.id
}

resource "aws_security_group_rule" "egress_tcp_all" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "1"
  to_port           = "65234"
  protocol          = "tcp"
  type              = "egress"
  security_group_id = aws_security_group.kurs-06-jf.id
}

resource "aws_security_group_rule" "egress_icmp_echo_request" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = "8"
  to_port           = "0"
  protocol          = "icmp"
  type              = "egress"
  security_group_id = aws_security_group.kurs-06-jf.id
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = ["kurs05-vk-subnet-01"]
  }
  vpc_id = data.aws_vpc.kurs05-vk.id
}

resource "aws_instance" "kurs-06-jf" {
  ami                         = data.aws_ami.bionic.id
  associate_public_ip_address = true
  instance_type               = "t2.nano"
  key_name                    = aws_key_pair.kurs-06-jf.key_name
  subnet_id                   = data.aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.kurs-06-jf.id]

  tags = {
    Name        = "kurs-06-jf"
    Description = "Instance kurs-06-jf"
    Environment = "day-02"
  }

  lifecycle {
    ignore_changes = ["user_data", "ami"]
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo sleep 20",
  #     "sudo apt-get -y update",
  #     "sudo sleep 20",
  #     "sudo apt-get -y install ansible",
  #   ]
  #
  #   connection {
  #     host        = aws_instance.kurs-06-jf.public_ip
  #     type        = "ssh"
  #     agent       = "false"
  #     private_key = file("~/.ssh/id_rsa")
  #     user        = "ubuntu"
  #   }
  # }
}

data "template_file" "ansible_inventory" {
  template = file("inventory.tpl")
  vars = {
    ip_address = aws_instance.kurs-06-jf.public_ip
  }
}

resource "local_file" "inventory" {
 content  = data.template_file.ansible_inventory.rendered
 filename = "${path.root}/ansible/inventory"
}

# resource "null_resource" "run_ansible" {
#   triggers = {
#     policy_sha1 = sha1(file("${path.root}/ansible/inventory"))
#   }
#   provisioner "local-exec" {
#     working_dir = "${path.root}/ansible/openvpn"
#     command     = "ansible-playbook -i ../inventory site.yml"
#   }
#   depends_on = ["aws_instance.kurs-06-jf"]
# }