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
resource "aws_network_interface" "icap_nic_pub_ec2_node_01" {
  subnet_id       = var.subnets[0].id
  security_groups = [var.security_group_for_nodes_id]
}

resource "aws_instance" "icap_ec2_node_01_iz" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  availability_zone = "${var.region}a" 
  key_name = var.pem_key_name
  user_data = "${file("modules/ec2/init.sh")}"
  
  tags = merge(
    var.common_tags,
    {
      Name = "icap_ec2_node_01_iz"
    },
  )
  
  network_interface {
    network_interface_id = aws_network_interface.icap_nic_pub_ec2_node_01.id
    device_index         = 0
  }
}

# =================Node-02===============

resource "aws_network_interface" "icap_nic_pub_ec2_node_02" {
  subnet_id       = var.subnets[2].id
  private_ips     = ["10.0.101.50"]
  security_groups = [var.security_group_for_nodes_id]
}


resource "aws_instance" "icap_ec2_node_02_iz" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  availability_zone = "${var.region}a" 
  key_name = var.pem_key_name
  user_data = "${file("modules/ec2/init2.sh")}"
  
  tags = merge(
    var.common_tags,
    {
      Name = "icap_ec2_node_02_iz"
    },
  )
 
  network_interface {
    network_interface_id = aws_network_interface.icap_nic_pub_ec2_node_02.id
    device_index         = 0
  }
}
