# 12. Create node instance
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

# 11. Create a Network Interface with static private IP inside private Subnet
resource "aws_network_interface" "icap_nic_pub_ec2_node40" {
  subnet_id       = var.subnets[2].id
  private_ips     = ["10.0.101.40"]
  security_groups = [var.security_group_for_nodes_id]
}

# 11. Create an Elastic IP and Assign to Network Interface 
resource "aws_eip" "icap_eip_ec2_node40" {
  vpc = true
  associate_with_private_ip = "10.0.101.40"
  network_interface         = aws_network_interface.icap_nic_pub_ec2_node40.id
  depends_on                = [aws_instance.icap_ec2_node40_ew1a, aws_network_interface.icap_nic_pub_ec2_node40]
  tags = merge(
    var.common_tags,
    {
      Name = "icap_eip_ec2_node40"
    },
  )
}



resource "aws_instance" "icap_ec2_node40_ew1a" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  availability_zone = "eu-west-1a" 
  key_name = "iz-gw-bastion-key"
  user_data = "${file("modules/ec2/init.sh")}"
  
  tags = merge(
    var.common_tags,
    {
      Name = "icap_ec2_node40_ew1a"
    },
  )
  # depends_on = [aws_vpc.vpc_icap_ew1]
  
  network_interface {
    network_interface_id = aws_network_interface.icap_nic_pub_ec2_node40.id
    device_index         = 0
  }
}

# ================================

resource "aws_network_interface" "icap_nic_pub_ec2_node50" {
  subnet_id       = var.subnets[2].id
  private_ips     = ["10.0.101.50"]
  security_groups = [var.security_group_for_nodes_id]
}

# 11. Create an Elastic IP and Assign to Network Interface 
resource "aws_eip" "icap_eip_ec2_node50" {
  vpc = true
  associate_with_private_ip = "10.0.101.50"
  network_interface         = aws_network_interface.icap_nic_pub_ec2_node50.id
  depends_on                = [aws_instance.icap_ec2_node50_ew1a, aws_network_interface.icap_nic_pub_ec2_node50]
  tags = merge(
    var.common_tags,
    {
      Name = "icap_eip_ec2_node50"
    },
  )
}

resource "aws_instance" "icap_ec2_node50_ew1a" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  availability_zone = "eu-west-1a" 
  key_name = "iz-gw-bastion-key"
  user_data = "${file("modules/ec2/init2.sh")}"
  
  tags = merge(
    var.common_tags,
    {
      Name = "icap_ec2_node50_ew1a"
    },
  )
 
  network_interface {
    network_interface_id = aws_network_interface.icap_nic_pub_ec2_node50.id
    device_index         = 0
  }
}
