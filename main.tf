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

module "vpc" {
  source = "./modules/vpc"
  common_tags = var.common_tags
}

module "ec2" {
  source = "./modules/ec2"
  common_tags = var.common_tags
  # network_interface_id_1 = module.vpc.network_interface_id_1
  subnet_prv_id = module.vpc.subnet_prv_id
  subnet_prv2_id = module.vpc.subnet_prv2_id
  security_group_for_nodes_id = module.vpc.security_group_for_nodes_id
}


module "elb" {
  source = "./modules/elb"
  common_tags = var.common_tags
  subnet_prv_id = module.vpc.subnet_prv_id
  security_group_for_nodes_id = module.vpc.security_group_for_nodes_id
  ec_instances = module.ec2.ec_instances
}