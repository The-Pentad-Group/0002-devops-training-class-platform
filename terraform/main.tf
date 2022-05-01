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


