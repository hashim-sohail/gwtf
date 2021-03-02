
# # 10. Create a Network Interface with static private IP inside private Subnet
# resource "aws_network_interface" "icap_nic_prv_ec1" {
#   subnet_id       = module.vpc.icap_subnet_prv_ew1b.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.sg_bastion_icap.id]
# }

# 11. Create an Elastic IP and Assign to Network Interface 

# resource "aws_eip" "eip_bastion_icap" {
#   vpc = true
#   associate_with_private_ip = "10.0.1.50"
#   network_interface         = aws_network_interface.nic_pub_bastion_icap.id
#   depends_on                = [aws_internet_gateway.igw_icap_ew1]
#   tags = merge(
#     var.common_tags,
#     {
#       Name = "eip_bastion_icap"
#     },
#   )
# }

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
resource "aws_network_interface" "icap_nic_prv_ec1" {
  subnet_id       = var.subnet_prv_id
  private_ips     = ["10.0.1.50"]
  security_groups = [var.security_group_for_nodes_id]
}


resource "aws_instance" "icap_ec2_node1_ew1b" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  availability_zone = "eu-west-1b" 
  key_name = "iz-gw-bastion-key"
  # user_data = "${file("init.sh")}"
  
  tags = merge(
    var.common_tags,
    {
      Name = "icap_ec2_node1_ew1b"
    },
  )
  # depends_on = [aws_vpc.vpc_icap_ew1]
  
  network_interface {
    network_interface_id = aws_network_interface.icap_nic_prv_ec1.id
    device_index         = 0
  }
}

# ================================

# 12. Create a Network Interface with static private IP inside private Subnet
resource "aws_network_interface" "icap_nic_prv_ec2" {
  subnet_id       = var.subnet_prv2_id
  private_ips     = ["10.0.2.60"]
  security_groups = [var.security_group_for_nodes_id]
}

resource "aws_instance" "icap_ec2_node2_ew1b" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  availability_zone = "eu-west-1c" 
  key_name = "iz-gw-bastion-key"
  # user_data = "${file("init.sh")}"
  
  tags = merge(
    var.common_tags,
    {
      Name = "icap_ec2_node2_ew1b"
    },
  )
 
  network_interface {
    network_interface_id = aws_network_interface.icap_nic_prv_ec2.id
    device_index         = 0
  }
}
