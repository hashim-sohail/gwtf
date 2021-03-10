locals {
  cluster_id_tag = {
    "kubernetes.io/cluster/${var.cluster_id}" = "owned"
  }
}

resource "aws_network_interface" "icap_nic_node" {
  count = 4

  subnet_id       = var.subnets[0].id
  security_groups = [var.security_group_for_nodes_id]
}

resource "aws_instance" "rke-node" {
  count = 4

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.rke-node-key.id
  iam_instance_profile   = aws_iam_instance_profile.rke-aws.name
  tags                   = local.cluster_id_tag

  network_interface {
    network_interface_id = aws_network_interface.icap_nic_node[count.index].id
    device_index         = 0
  }

  provisioner "remote-exec" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.node-key.private_key_pem
    }

    inline = [
      "curl ${var.docker_install_url} | sh",
      "sudo usermod -a -G docker ubuntu",
    ]
  }
}

