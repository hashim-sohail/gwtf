terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    rke = {
      source = "rancher/rke"
      version = "1.2.1"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_azs = ["${var.region}a", "${var.region}b"]
  common_tags = var.common_tags
}

#module "ec2" {
#  source = "./modules/ec2"
#  common_tags = var.common_tags
#  subnets = [module.vpc.subnets_pub1]
#  region  = var.region
#  security_group_for_nodes_id = module.vpc.security_group_for_nodes_id
#}

module "nodes" {
  source = "./modules/rke_cluster"
  region        = var.region
  instance_type = "t2.large"
  cluster_id    = "rke"
  security_group_for_nodes_id = module.vpc.security_group_for_nodes_id
}

resource "rke_cluster" "cluster" {
  cloud_provider {
    name = "aws"
  }

  nodes {
    address = module.nodes.addresses[0]
    internal_address = module.nodes.internal_ips[0]
    user    = module.nodes.ssh_username
    ssh_key = module.nodes.private_key
    role    = ["controlplane", "etcd"]
  }
  nodes {
    address = module.nodes.addresses[1]
    internal_address = module.nodes.internal_ips[1]
    user    = module.nodes.ssh_username
    ssh_key = module.nodes.private_key
    role    = ["worker"]
  }
  nodes {
    address = module.nodes.addresses[2]
    internal_address = module.nodes.internal_ips[2]
    user    = module.nodes.ssh_username
    ssh_key = module.nodes.private_key
    role    = ["worker"]
  }
  nodes {
    address = module.nodes.addresses[3]
    internal_address = module.nodes.internal_ips[3]
    user    = module.nodes.ssh_username
    ssh_key = module.nodes.private_key
    role    = ["worker"]
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "./kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
}

#resource "null_resource" "create_icap_pods" {

#  provisioner "local-exec" {
#    command = "/bin/bash create_icap.sh"
#  }
#}

module "elb" {
  source = "./modules/elb"
  common_tags = var.common_tags
  subnets = [module.vpc.subnets_pub1]
  security_group_for_nodes_id = module.vpc.security_group_for_nodes_id
  ec_instances = module.nodes.ec_instances
}
