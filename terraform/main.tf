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
  version                = "~> 1.11"
}

locals {
  cluster_name = "my-cluster"
}