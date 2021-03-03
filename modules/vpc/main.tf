
# 1. Create vpc
resource "aws_vpc" "icap_vpc_iz"{
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
      var.common_tags,
    {
      Name = "icap_vpc_iz"
    },
  )
}

# 02. Create Internet Gateway
resource "aws_internet_gateway" "icap_igw_iz" {
  vpc_id = aws_vpc.icap_vpc_iz.id
  tags = merge(
    var.common_tags,
    {
      Name = "icap_igw_iz"
    },
  )
  depends_on = [aws_vpc.icap_vpc_iz]
}

# 03. Create Subnet public
resource "aws_subnet" "icap_subnet_pub_iz" {
  vpc_id     = aws_vpc.icap_vpc_iz.id
  cidr_block = var.vpc_public_subnets_cidr[0]
  availability_zone = var.vpc_azs[0]
  map_public_ip_on_launch = "true"
  tags = merge(
    var.common_tags,
    {
      Name = "icap_subnet_pub_iz"
    },
  )
  depends_on = [aws_vpc.icap_vpc_iz]
}

# # 04. Create Route Table public
# #  No need to create, it is created by default with VPC

# 05. Create Route in public Route Table (default of vpc) to allow all trafic to Internet Gateway
resource "aws_route" "icap_route_ingress_pub_iz" {
  route_table_id            = aws_vpc.icap_vpc_iz.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.icap_igw_iz.id
  depends_on = [aws_vpc.icap_vpc_iz,aws_internet_gateway.icap_igw_iz, aws_subnet.icap_subnet_pub_iz]
}

# 06. Associate public Route Table with public Subnet
resource "aws_route_table_association" "icap_rta_pub_iz" {
  subnet_id      = aws_subnet.icap_subnet_pub_iz.id
  route_table_id = aws_vpc.icap_vpc_iz.default_route_table_id
  depends_on = [aws_vpc.icap_vpc_iz,aws_internet_gateway.icap_igw_iz, aws_subnet.icap_subnet_pub_iz]
}

# 10. Create security group for nodes
resource "aws_security_group" "icap_sg_nodes" {
  name        = "allow_ssh"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.icap_vpc_iz.id

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
