provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tpg-training-remotestate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

locals {
  cluster_name = "my-cluster"
}

data "aws_availability_zones" "available" {
}

data "aws_eks_cluster" "cluster" {
 name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
 name = module.eks.cluster_id
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.13.0"

  name                 = "k8s-vpc"
  cidr                 = "172.16.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnets       = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.15.0"

  cluster_name    = "${local.cluster_name}"
  cluster_version = "1.21"
  subnet_ids         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id
}