provider "aws" {
  region = "us-east-1"
}

# terraform {
#   backend "local" {
#     path = "/your/path/to/terraform.tfstate"
#   }
# }

terraform {
  backend "s3" {
    bucket = "your-bucket-name"
    key    = "your-tf-state-name.tfstate"
    region = "your-region-name-1"
  }
}
