data "template_file" "ansible_inventory" {
  template = file("./inventory.tpl")
  vars = {
    hostname = "win-example-jf.terraform-training.de"
    username = var.INSTANCE_USERNAME
    password = var.INSTANCE_PASSWORD
  }
}

resource "local_file" "inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${path.root}/ansible/inventory"
}

resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
    working_dir = "${path.root}/ansible"
    command     = "ansible-playbook -i inventory site.yml"
  }
  depends_on = [aws_instance.win-example]
}
