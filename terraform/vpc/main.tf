terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = local.region
}

locals {
  service = "ICAP Cluster"
  delete  = "Yes"
  owner   = "Khawar"
  team    = "DevOps"
  scope   = "Created for demo purpose"
  region  = "eu-west-1"
  aza     = "eu-west-1a"
  azb     = "eu-west-1b"
  azc     = "eu-west-1c"
  env     = "dev"
}


locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service = local.service
    Owner   = local.owner
    Delete  = local.delete
    Team    = local.team
    Scope   = local.scope
    Evn     = local.env
  }
}

# 1. Create vpc
resource "aws_vpc" "vpc_icap_ew1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = merge(
    local.common_tags,
    {
      Name = "vpc_icap_ew1"
    },
  )
}

# 02. Create Internet Gateway
resource "aws_internet_gateway" "igw_icap_ew1" {
  vpc_id = aws_vpc.vpc_icap_ew1.id

  tags = merge(
    local.common_tags,
    {
      Name = "igw_icap_ew1"
    },
  )
  depends_on = [aws_vpc.vpc_icap_ew1]
}

# 03. Create Subnet public
resource "aws_subnet" "subnet_pub_icap_ew1a" {
  vpc_id     = aws_vpc.vpc_icap_ew1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = "true"
  tags = merge(
    local.common_tags,
    {
      Name = "subnet_pub_icap_ew1a"
    },
  )
  depends_on = [aws_vpc.vpc_icap_ew1]
}
# 04. Create Route Table public
#  No need to create, it is created by default with VPC

# 05. Create Route in public Route Table (default of vpc) to allow all trafic to Internet Gateway
resource "aws_route" "r_ing_pub_icap_ew1a" {
  route_table_id            = aws_vpc.vpc_icap_ew1.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw_icap_ew1.id
  depends_on = [aws_vpc.vpc_icap_ew1,aws_internet_gateway.igw_icap_ew1, aws_subnet.subnet_pub_icap_ew1a]
}
# 06. Associate Route Table public with Subnet public
resource "aws_route_table_association" "rta_pub_icap_ew1a" {
  subnet_id      = aws_subnet.subnet_pub_icap_ew1a.id
  route_table_id = aws_vpc.vpc_icap_ew1.default_route_table_id
  depends_on = [aws_vpc.vpc_icap_ew1,aws_internet_gateway.igw_icap_ew1, aws_subnet.subnet_pub_icap_ew1a]
}

# 07. Create Subnet private
resource "aws_subnet" "subnet_prv_icap_ew1b" {
  vpc_id     = aws_vpc.vpc_icap_ew1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  # map_public_ip_on_launch = "false"
  tags = merge(
    local.common_tags,
    {
      Name = "subnet_prv_icap_ew1b"
    },
  )
  depends_on = [aws_vpc.vpc_icap_ew1]
}

# 08. Create Route Table private
resource "aws_route_table" "rt_prv_icap_ew1b" {
  vpc_id = aws_vpc.vpc_icap_ew1.id
  tags = merge(
    local.common_tags,
    {
      Name = "rt_prv_icap_ew1b"
    },
  )
  depends_on = [aws_vpc.vpc_icap_ew1, aws_subnet.subnet_prv_icap_ew1b]
}

# 09. Associate private Route Table with private Subnet  
resource "aws_route_table_association" "rta_prv_icap_ew1b" {
  subnet_id      = aws_subnet.subnet_prv_icap_ew1b.id
  route_table_id = aws_route_table.rt_prv_icap_ew1b.id
  depends_on = [aws_vpc.vpc_icap_ew1, aws_subnet.subnet_prv_icap_ew1b,aws_route_table.rt_prv_icap_ew1b]
}

# 10. Create security group
resource "aws_security_group" "sg_bastion_icap" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc_icap_ew1.id

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from everywhere"
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

  tags = {
    Name = "allow_ssh"
  }
}

# 10. Create a Network Interface with static private IP inside Public Subnet
resource "aws_network_interface" "nic_pub_bastion_icap" {
  subnet_id       = aws_subnet.subnet_pub_icap_ew1a.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.sg_bastion_icap.id]
}

# 11. Create an Elastic IP and Assign to Network Interface 
resource "aws_eip" "eip_bastion_icap" {
  vpc = true
  associate_with_private_ip = "10.0.1.50"
  network_interface         = aws_network_interface.nic_pub_bastion_icap.id
  depends_on                = [aws_internet_gateway.igw_icap_ew1]
  tags = merge(
    local.common_tags,
    {
      Name = "eip_bastion_icap"
    },
  )
}

# 12. Create Bastion server
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


resource "aws_instance" "bastion_icap_ew1a" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  availability_zone = "eu-west-1a" 
  key_name = "iz-gw-bastion-key"
  user_data = "${file("init.sh")}"
  
  tags = merge(
    local.common_tags,
    {
      Name = "bastion_icap_ew1a"
    },
  )
  depends_on = [aws_vpc.vpc_icap_ew1]
  
  network_interface {
    network_interface_id = aws_network_interface.nic_pub_bastion_icap.id
    device_index         = 0
  }
}
