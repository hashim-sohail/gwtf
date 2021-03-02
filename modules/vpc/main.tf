
# 1. Create vpc
resource "aws_vpc" "icap_vpc_ew1"{
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
      var.common_tags,
    {
      Name = "icap_vpc_ew1"
    },
  )
}

# 02. Create Internet Gateway
resource "aws_internet_gateway" "icap_igw_ew1" {
  vpc_id = aws_vpc.icap_vpc_ew1.id
  tags = merge(
    var.common_tags,
    {
      Name = "icap_igw_ew1"
    },
  )
  depends_on = [aws_vpc.icap_vpc_ew1]
}

# 03. Create Subnet public
resource "aws_subnet" "icap_subnet_pub_ew1a" {
  vpc_id     = aws_vpc.icap_vpc_ew1.id
  cidr_block = var.vpc_public_subnets_cidr[0]
  availability_zone = var.vpc_azs[0]
  map_public_ip_on_launch = "true"
  tags = merge(
    var.common_tags,
    {
      Name = "icap_subnet_pub_ew1a"
    },
  )
  depends_on = [aws_vpc.icap_vpc_ew1]
}

# # 04. Create Route Table public
# #  No need to create, it is created by default with VPC

# 05. Create Route in public Route Table (default of vpc) to allow all trafic to Internet Gateway
resource "aws_route" "icap_route_ingress_pub_ew1a" {
  route_table_id            = aws_vpc.icap_vpc_ew1.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.icap_igw_ew1.id
  depends_on = [aws_vpc.icap_vpc_ew1,aws_internet_gateway.icap_igw_ew1, aws_subnet.icap_subnet_pub_ew1a]
}

# 06. Associate public Route Table with public Subnet
resource "aws_route_table_association" "icap_rta_pub_ew1a" {
  subnet_id      = aws_subnet.icap_subnet_pub_ew1a.id
  route_table_id = aws_vpc.icap_vpc_ew1.default_route_table_id
  depends_on = [aws_vpc.icap_vpc_ew1,aws_internet_gateway.icap_igw_ew1, aws_subnet.icap_subnet_pub_ew1a]
}

# 07. Create Subnet private
resource "aws_subnet" "icap_subnet_prv_ew1b" {
  vpc_id     = aws_vpc.icap_vpc_ew1.id
  cidr_block = var.vpc_private_subnets_cidr[0]
  availability_zone = var.vpc_azs[1]
  tags = merge(
    var.common_tags,
    {
      Name = "icap_subnet_prv_ew1b"
    },
  )
  depends_on = [aws_vpc.icap_vpc_ew1]
}

# 07. Create Subnet private
resource "aws_subnet" "icap_subnet_prv2_ew1b" {
  vpc_id     = aws_vpc.icap_vpc_ew1.id
  cidr_block = var.vpc_private_subnets_cidr[1]
  availability_zone = var.vpc_azs[2]
  tags = merge(
    var.common_tags,
    {
      Name = "icap_subnet_prv2_ew1b"
    },
  )
  depends_on = [aws_vpc.icap_vpc_ew1]
}

# 08. Create Route Table private
resource "aws_route_table" "icap_routetable_prv_ew1b" {
  vpc_id = aws_vpc.icap_vpc_ew1.id
  tags = merge(
    var.common_tags,
    {
      Name = "icap_routetable_prv_ew1b"
    },
  )
  depends_on = [aws_vpc.icap_vpc_ew1, aws_subnet.icap_subnet_prv_ew1b]
}

# 09. Associate private Route Table with private Subnet  
resource "aws_route_table_association" "icap_rta_prv_ew1b" {
  subnet_id      = aws_subnet.icap_subnet_prv_ew1b.id
  route_table_id = aws_route_table.icap_routetable_prv_ew1b.id
  depends_on = [aws_vpc.icap_vpc_ew1, aws_subnet.icap_subnet_prv_ew1b,aws_route_table.icap_routetable_prv_ew1b]
}

resource "aws_route_table_association" "icap_rta_prv2_ew1b" {
  subnet_id      = aws_subnet.icap_subnet_prv2_ew1b.id
  route_table_id = aws_route_table.icap_routetable_prv_ew1b.id
  depends_on = [aws_vpc.icap_vpc_ew1, aws_subnet.icap_subnet_prv2_ew1b,aws_route_table.icap_routetable_prv_ew1b]
}

# 10. Create security group for nodes
resource "aws_security_group" "icap_sg_nodes" {
  name        = "allow_ssh"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.icap_vpc_ew1.id

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "allow_ssh"
    },
  )
}

# # 11. Create a Network Interface with static private IP inside private Subnet
# resource "aws_network_interface" "icap_nic_prv_ec1" {
#   subnet_id       = aws_subnet.icap_subnet_prv_ew1b.id
#   private_ips     = ["10.0.1.50"]
#   security_groups = [aws_security_group.icap_sg_nodes.id]
# }


# # 11. Create a Network Interface with static private IP inside private Subnet
# resource "aws_network_interface" "icap_nic_prv_ec2" {
#   subnet_id       = aws_subnet.icap_subnet_prv_ew1b.id
#   private_ips     = ["10.0.1.60"]
#   security_groups = [aws_security_group.icap_sg_nodes.id]
# }