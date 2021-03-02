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
  region  = var.region
}


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

# 10. Create security group for nodes
resource "aws_security_group" "icap_sg_bastion" {
  name        = "allow_ssh_http"
  # vpc_id      = aws_vpc.aws_default_vpc.id
  description = "Allow HTTP inbound traffic"

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
      Name = "allow_ssh_http"
    },
  )
}

resource "aws_instance" "icap_ec2_bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  # provisioner "file" {
  #   source      = "~/.ssh/id_rsa.pub"
  #   destination = "/tmp/id_rsa.pub"
  #   # depends_on = [aws_instance.icap_ec2_bastion]
  # }
  availability_zone = "${var.region}a" 
  # security_groups = [aws_security_group.icap_sg_bastion.id]
  key_name = var.pem_key_name
  user_data = "${file("init.sh")}"
  
  tags = merge(
    var.common_tags,
    {
      Name = "icap_ec2_bastion"
    },
  )  
}

resource "aws_eip" "icap_eip_bastion" {
  instance = aws_instance.icap_ec2_bastion.id
  vpc      = true
}


resource "aws_network_interface_sg_attachment" "icap_sg_attachment" {
  security_group_id    = aws_security_group.icap_sg_bastion.id
  network_interface_id = aws_instance.icap_ec2_bastion.primary_network_interface_id
}