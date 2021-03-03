terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "gw"
  region  = var.region
}

module "vpc" {
  source = "./modules/vpc"
  common_tags = var.common_tags
}

module "ec2" {
  source = "./modules/ec2"
  common_tags = var.common_tags
  subnets = [module.vpc.subnet_pub1]
  region  = var.region
  security_group_for_nodes_id = module.vpc.security_group_for_nodes_id
}


module "elb" {
  source = "./modules/elb"
  common_tags = var.common_tags
  subnets = [module.vpc.subnet_pub1]
  security_group_for_nodes_id = module.vpc.security_group_for_nodes_id
  ec_instances = module.ec2.ec_instances
}