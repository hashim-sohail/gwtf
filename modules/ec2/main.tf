locals {
  cluster_id_tag = {
    "kubernetes.io/cluster/${var.cluster_id}" = "owned"
  }
}

# Create node instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# =================Node-01===============
# Create a Network Interface
#resource "aws_network_interface" "icap_nic_pub_ec2_node_01" {
#  subnet_id       = var.subnets[0].id
#  security_groups = [var.security_group_for_nodes_id]
#}

#resource "aws_instance" "icap_ec2_node_01_iz" {
#  ami           = data.aws_ami.ubuntu.id
#  instance_type = "t3.micro"
#  availability_zone = "${var.region}a"
#  key_name = var.pem_key_name
#  user_data = "${file("modules/ec2/init.sh")}"

#  tags = merge(
#    var.common_tags,
#    {
#      Name = "icap_ec2_node_01_iz"
#    },
#  )

#  network_interface {
#    network_interface_id = aws_network_interface.icap_nic_pub_ec2_node_01.id
#    device_index         = 0
#  }
#}

# =================Node-02===============

#resource "aws_network_interface" "icap_nic_pub_ec2_node_02" {
#  subnet_id       = var.subnets[0].id
#  # private_ips     = ["10.0.101.50"]
#  security_groups = [var.security_group_for_nodes_id]
#}


#resource "aws_instance" "icap_ec2_node_02_iz" {
#  ami           = data.aws_ami.ubuntu.id
#  instance_type = "t3.micro"
#  availability_zone = "${var.region}a" 
#  key_name = var.pem_key_name
#  user_data = "${file("modules/ec2/init2.sh")}"
  
#  tags = merge(
#    var.common_tags,
#    {
#      Name = "icap_ec2_node_02_iz"
#    },
#  )
 
#  network_interface {
#    network_interface_id = aws_network_interface.icap_nic_pub_ec2_node_02.id
#    device_index         = 0
#  }
#}

data "aws_availability_zones" "az" {
}

resource "aws_default_subnet" "default" {
  availability_zone = data.aws_availability_zones.az.names[count.index]
  tags              = local.cluster_id_tag
  count             = length(data.aws_availability_zones.az.names)
}


resource "aws_network_interface" "icap_nic_pub_ec2_node" {
  count = 4

  subnet_id       = var.subnets[0].id
  # private_ips     = ["10.0.101.50"]
  security_groups = [var.security_group_for_nodes_id]
}

resource "aws_instance" "rke-node" {
  count = 4

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.rke-node-key.id

  #vpc_security_group_ids = [var.security_group_for_nodes_id]

  tags = merge(
    var.common_tags,
    {
      Name = "icap_ec2_node_02_iz"
    },
    local.cluster_id_tag
  )

  network_interface {
    network_interface_id = aws_network_interface.icap_nic_pub_ec2_node[count.index].id
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
      "sudo apt update",
      "curl ${var.docker_install_url} | sh",
      "sudo usermod -a -G docker ubuntu",
      "sudo apt install c-icap -y"
    ]
  }
}