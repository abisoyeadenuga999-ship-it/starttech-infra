terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source       = "./modules/networking"
  cluster_name = var.cluster_name
}

module "storage" {
  source = "./modules/storage"
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids  = module.networking.public_subnet_ids
}

module "database" {
  source                     = "./modules/database"
  vpc_id                     = module.networking.vpc_id
  private_subnet_ids         = module.networking.private_subnet_ids
  eks_node_security_group_id = module.eks.node_security_group_id
}
